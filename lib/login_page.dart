// ignore_for_file: sort_child_properties_last

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // محاولة تسجيل الدخول
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // التحقق مما إذا كان البريد الإلكتروني قد تم التحقق منه
      if (!userCredential.user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please verify your email')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // الانتقال إلى الصفحة الرئيسية إذا كان التحقق ناجحًا
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email does not exist')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                      TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 214, 212, 212),
                            ),
                            hintText: 'Email',
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
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) => (_email = value!,)),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: "os-semibold",
                            color: Color(0xff333333)),
                        prefixIcon: Icon(
                          Icons.password_sharp,
                          color: Color.fromARGB(255, 214, 212, 212),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFFD6D4D4),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: Color(0xffF7DC6F), width: 2)),
                        errorStyle: TextStyle(
                            color:
                                Colors.red), // تعيين لون رسالة الخطأ إلى الأحمر
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        } else if (!RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                            .hasMatch(value)) {
                          return 'Password must include letters, numbers, and special characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value; // حفظ كلمة المرور في المتغير
                          if (value.isNotEmpty) {
                            _checkPasswordStrength(value);
                          } else {
                            _passwordStrength = '';
                          }
                        });
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    if (_password.isNotEmpty) SizedBox(height: 5),
                    if (_password.isNotEmpty)
                      Text(
                        'Password Strength: $_passwordStrength',
                        style: TextStyle(color: _getPasswordStrengthColor()),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                activeColor: Color(accentcolor),
                                value: isChecked,
                                onChanged: (newbool) {
                                  setState(() {
                                    isChecked = newbool;
                                  });
                                }),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                  fontFamily: "os-semibold",
                                  fontSize: 13,
                                  color: Color(textcolor)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
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
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/home");
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _login();
                        }
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text(
                        //     'Please check your email',
                        //     style: TextStyle(
                        //       fontFamily: "os-semibold",
                        //       fontSize: 14,
                        //     ),
                        //   )),
                        // );
                      },
                      child: Center(
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "os-semibold",
                              color: Color(0xffFFFFFF)),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(pcolor)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 6,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
