// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final _formKey1 = GlobalKey<FormState>(); // نموذج للمستخدم التجاري
  final _formKey2 = GlobalKey<FormState>(); // نموذج للمستخدم غير التجاري
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _phoneNumber = '';
  String _countryCode = '+1'; // Default country code
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _passwordStrength = '';
  String _userType = 'Commercial'; // نوع العميل
  bool _emailExists = false; // للتحقق من وجود البريد الإلكتروني
  bool _phoneExists = false; // للتحقق من وجود رقم الهاتف

  XFile? _image1;
  XFile? _image2;
  String? _imageUrl1;
  String? _imageUrl2;

  late TabController _tabController;

  void _register() async {
    setState(() {
      _isLoading = true;
      _emailExists = false; // إعادة تعيين الحالة
      _phoneExists = false; // إعادة تعيين الحالة
    });

    try {
      // التحقق من وجود البريد الإلكتروني
      final QuerySnapshot emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: _email)
          .limit(1)
          .get();
      if (emailQuery.docs.isNotEmpty) {
        setState(() {
          _emailExists = true; // تحديث الحالة ليظهر الخطأ تحت حقل البريد
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Email already exists'),
              backgroundColor: Colors.red),
        );
        setState(() {
          _isLoading = false;
        });

        return; // إيقاف العملية هنا
      }

      // التحقق من وجود رقم الهاتف
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: '$_countryCode$_phoneNumber')
          .get();
      if (result.docs.isNotEmpty) {
        setState(() {
          _phoneExists = true; // رقم الهاتف موجود
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Phone number already exists'),
              backgroundColor: Colors.red),
        );
        setState(() {
          _isLoading = false;
        });
        return; // لا تتابع إذا كان رقم الهاتف موجودًا
      }
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // تشفير كلمة المرور
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encryptedPassword = encrypter.encrypt(_password, iv: iv);

      // التحقق من رفع الصور
      if (_image1 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload ID image')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (_userType == 'Commercial' && _image2 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload License image')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // تسجيل البيانات في Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': _firstName,
        'lastName': _lastName,
        'email': _email,
        'phoneNumber': '$_countryCode$_phoneNumber',
        'password': encryptedPassword.base64, // حفظ كلمة المرور المشفرة
        'image1': _imageUrl1,
        'image2': _imageUrl2,
        'userType': _userType, // تخزين نوع العميل
      });

      await userCredential.user!.updateDisplayName(_firstName);
      await userCredential.user!.sendEmailVerification();

      // جدولة حذف الحساب إذا لم يتم التفعيل خلال دقيقتين
      Timer(Duration(minutes: 2), () async {
        try {
          User? user = _auth.currentUser;
          if (user != null && !user.emailVerified) {
            String uid = user.uid;

            // حذف البيانات المرتبطة بالمستخدم في Firestore
            await _firestore.collection('users').doc(uid).delete();

            // حذف المستخدم من Firebase Authentication
            await user.delete();

            print(
                'User and associated data have been deleted due to email not verified.');
          }
        } catch (e) {
          print('Error while deleting user or associated data: $e');
        }
      });

      // الانتقال إلى صفحة تسجيل الدخول بعد إرسال رابط التفعيل
      Navigator.pushReplacementNamed(context, '/login');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xffECF0F6),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Please check you email for verification",
                style: TextStyle(
                    fontFamily: "os-semibold",
                    fontSize: 16,
                    color: Color(0xff333333)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff5D8FD1)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                        side: BorderSide(
                          color: Color(0xffE8E8E8),
                        ))),
                    shadowColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 213, 211, 211))),
                child: Text(
                  'ok',
                  style: TextStyle(
                      fontFamily: "os-bold", fontSize: 14, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageNumber == 1) {
        _image1 = pickedImage;
        _imageUrl1 = pickedImage?.path;
      } else if (imageNumber == 2) {
        _image2 = pickedImage;
        _imageUrl2 = pickedImage?.path;
      }
    });
  }

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _formKey1.currentState?.reset();
        _formKey2.currentState?.reset();
        setState(() {
          _firstName = '';
          _lastName = '';
          _email = '';
          _password = '';
          _confirmPassword = '';
          _phoneNumber = '';
          _image1 = null;
          _image2 = null;
          _imageUrl1 = null;
          _imageUrl2 = null;
          _userType = _tabController.index == 0
              ? 'Commercial'
              : 'Non-commercial'; // تحديث نوع العميل
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Color.fromARGB(0, 158, 158, 163),
          title: Text(
            'Sign up',
            style: TextStyle(fontFamily: "os-bold", fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            labelColor: Color(0xff002F6C),
            labelStyle: TextStyle(fontFamily: "os-bold", fontSize: 14),
            dividerColor: Color(0xffCCCCCC),
            indicatorColor: Color(0xffFFC107),
            controller: _tabController,
            tabs: [
              Tab(text: 'Commercial'),
              Tab(text: 'Non-commercial'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics:
              NeverScrollableScrollPhysics(), // تعطيل السحب بين علامات التبويب
          children: [
            _buildRegistrationForm('Commercial', _formKey1),
            _buildRegistrationForm('Non-commercial', _formKey2),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(String userType, GlobalKey<FormState> formKey) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: 2),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        child: _buildFirstNameField(),
                        width: MediaQuery.of(context).size.width * 0.45,
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: _buildLastNameField()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildEmailField(),
              if (_emailExists) // عرض رسالة الخطأ إذا كان البريد الإلكتروني موجودًا
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Email already exists',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 10),
              _buildPasswordField(),
              SizedBox(height: 10),
              _buildConfirmPasswordField(),
              SizedBox(height: 10),
              _buildPhoneNumberField(),
              if (_phoneExists) // عرض رسالة الخطأ إذا كان رقم الهاتف موجودًا
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Phone number already exists',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 10),
              _buildImagePicker(1),
              if (userType == 'Commercial') _buildImagePicker(2),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          _register();
                        }
                      },
                      child: Center(
                        child: Text(
                          'Create account',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "os-semibold",
                              color: Color(0xffFFFFFF)),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff002F6C)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                      ),
                    ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(int imageNumber) {
    return FormField<XFile>(
      validator: (value) {
        if (value == null) {
          return 'Please upload ${imageNumber == 1 ? 'ID' : 'License'} image';
        }
        return null;
      },
      builder: (FormFieldState<XFile> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                XFile? pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                state.didChange(pickedImage);
                setState(() {
                  if (imageNumber == 1) {
                    _image1 = pickedImage;
                    _imageUrl1 = pickedImage?.path;
                  } else if (imageNumber == 2) {
                    _image2 = pickedImage;
                    _imageUrl2 = pickedImage?.path;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      imageNumber == 1 ? 'Upload ID' : 'Upload License',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "os-semibold",
                          color: Color(0xff333333)),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        imageNumber == 1
                            ? (_image1 == null
                                ? "No image selected"
                                : _image1!.name)
                            : (_image2 == null
                                ? "No image selected"
                                : _image2!.name),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.upload_file,
                      color: Color(0xFFD6D4D4),
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromARGB(255, 214, 212, 212),
        ),
        hintText: 'First Name',
        hintStyle: TextStyle(
            fontSize: 13, fontFamily: "os-semibold", color: Color(0xff333333)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xffF7DC6F), width: 1.8)),
        errorStyle:
            TextStyle(color: Colors.red), // تعيين لون رسالة الخطأ إلى الأحمر
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
      onSaved: (value) => _firstName = value!,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Last Name',
        hintStyle: TextStyle(
            fontSize: 13, fontFamily: "os-semibold", color: Color(0xff333333)),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromARGB(255, 214, 212, 212),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xffCCCCCC))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xffF7DC6F), width: 2)),
        errorStyle:
            TextStyle(color: Colors.red), // تعيين لون رسالة الخطأ إلى الأحمر
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
      onSaved: (value) => _lastName = value!,
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                borderSide: BorderSide(color: Color(0xffF7DC6F), width: 1.8)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.deepPurple)),
          ),
          validator: (value) {
            if (value!.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: (value) => (_email = value!),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                borderSide: BorderSide(color: Color(0xffF7DC6F), width: 2)),
            errorStyle: TextStyle(
                color: Colors.red), // تعيين لون رسالة الخطأ إلى الأحمر
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
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        hintStyle: TextStyle(
            fontSize: 13, fontFamily: "os-semibold", color: Color(0xff333333)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xffF7DC6F), width: 2)),
        prefixIcon: Icon(
          Icons.password,
          color: Color.fromARGB(255, 214, 212, 212),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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
        errorStyle:
            TextStyle(color: Colors.red), // تعيين لون رسالة الخطأ إلى الأحمر
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Confirm Password is required';
        } else if (value != _password) {
          return 'Passwords do not match';
        }
        return null;
      },
      onSaved: (value) => _confirmPassword = value!,
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(children: [
      CountryCodePicker(
        onChanged: (code) {
          setState(() {
            _countryCode = code.dialCode!;
          });
        },
        initialSelection: 'US',
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        favorite: ['US', 'CA'],
      ),
      Expanded(
        child: TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontSize: 13,
                fontFamily: "os-semibold",
                color: Color(0xff333333)),
            prefixIcon: Icon(
              Icons.phone,
              color: Color.fromARGB(255, 214, 212, 212),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Color(0xffF7DC6F), width: 2)),

            hintText: 'Phone Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorStyle: TextStyle(
                color: Colors.red), // تعيين لون رسالة الخطأ إلى الأحمر
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
          onSaved: (value) => _phoneNumber = value!,
        ),
      )
    ]);
  }
}
