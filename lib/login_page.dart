// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cvsr/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int pcolor = 0xff002F6C;
  int scolor = 0xffF7DC6F;
  int textcolor = 0xff333333;
  int bordercol = 0xffCCCCCC;
  int shadow = 0xffE8E8E8;
  int accentcolor = 0xffFFC107;
  bool isSwithed = false;
  bool _isPasswordVisible = false;
  bool? isChecked = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _passwordStrength = '';
  String _password = '';
  String? _errorMessage;
  bool _obscureText = true;
  bool _isPhoneLogin = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _emailOrPhone = '';
  String _countryCode = '+1'; // Default country code
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // تأكد من أن المستخدم قد أدخل بيانات في كل الحقول
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('يرجى إدخال الإيميل وكلمة المرور'),
      ));
      return;
    }

    try {
      // محاولة تسجيل الدخول باستخدام Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // إذا كانت البيانات صحيحة، انتقل إلى الصفحة الرئيسية
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),  // توجه إلى صفحة Home
      );
    } on FirebaseAuthException catch (e) {
      // التعامل مع الأخطاء
      String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
      if (e.code == 'user-not-found') {
        errorMessage = 'المستخدم غير موجود';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور خاطئة';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    void _checkPasswordStrength(String value) {
      if (value.length < 8) {
        _passwordStrength = 'Weak';
      } else if (value.length < 12) {
        _passwordStrength = 'Medium';
      } else {
        _passwordStrength = 'Strong';
      }
    }

    Color _getPasswordStrengthColor() {
      switch (_passwordStrength) {
        case 'Weak':
          return Colors.red;
        case 'Medium':
          return Colors.orange;
        case 'Strong':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Color.fromARGB(0, 158, 158, 163),
        title: Text(
          'Log in',
          style: TextStyle(fontFamily: "os-bold", fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 3, right: 3),
                  width: 385,
                  height: 240,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(pcolor),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(pcolor),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ]),
                  child: Image.asset(
                    "assets/img/p2.png",
                    width: 300,
                    height: 250,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 3, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: TextStyle(
                          fontFamily: "os-bold",
                          fontSize: 16,
                          color: Color(textcolor)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Let’s continue what we were working on.",
                      style: TextStyle(
                          fontFamily: "os-bold",
                          fontSize: 13,
                          color: Color(bordercol)),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Log in with phone number",
                          style: TextStyle(
                              fontFamily: "os-reg",
                              fontSize: 15,
                              color: Color(textcolor)),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Switch(
                            activeColor: Color(accentcolor),
                            activeTrackColor: Color(scolor),
                            value: isSwithed,
                            onChanged: (value) {
                              setState(() {
                                isSwithed = value;
                              });
                            })
                      ],
                    ),
                    if (isSwithed)
                      Row(
                        children: [
                          CountryCodePicker(
                            // onChanged: (code) {
                            //   setState(() {
                            //     _countryCode = code.dialCode!;
                            //   });
                            // },
                            initialSelection: 'US',
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            favorite: ['US', 'CA'],
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(1),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(255, 214, 212, 212),
                                ),
                                hintText: 'Phone',
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "os-semibold",
                                    color: Color(0xff333333)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Color(0xffF7DC6F), width: 1.8)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple)),
                                errorStyle: TextStyle(
                                    color: Colors
                                        .red), // تعيين لون رسالة الخطأ إلى الأحمر
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Color(0xFFD6D4D4)),
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xffF7DC6F), width: 1.8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFD6D4D4)),
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xffF7DC6F), width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFFD6D4D4),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _checkPasswordStrength(value);
                        });
                      },
                    ),
                    if (_passwordStrength.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Password Strength: $_passwordStrength',
                          style: TextStyle(color: _getPasswordStrengthColor()),
                        ),
                      ),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                  fontFamily: "os-semibold",
                                  fontSize: 13,
                                  color: Color(textcolor)),
                            ),
                          ],
                        ),
              ),
                        InkWell(
                          child: Text(
                            "forget Password?",
                            style: TextStyle(
                                fontFamily: "os-semibold",
                                fontSize: 13,
                                color: Color(accentcolor)),
                          ),
                          onTap: () {},
                        ),

                    SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: _login,
                      child: Center(
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "os-semibold",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF6A1B9A)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/regesitration');
                      },
                      child: Center(
                        child: Text(
                          'Create account',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "os-semibold",
                              color: Color(pcolor)),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: Color(bordercol), width: 1.5))),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),

                ],
    ),
              ),),);
  }
}
