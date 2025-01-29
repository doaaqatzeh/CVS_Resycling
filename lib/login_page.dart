// ignore_for_file: sort_child_properties_last

import 'package:country_code_picker/country_code_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 10,
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
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(1),
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
                              borderSide: BorderSide(color: Colors.deepPurple)),
                          errorStyle: TextStyle(
                              color: Colors
                                  .red), // تعيين لون رسالة الخطأ إلى الأحمر
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(1),
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
                            "forgrt Password?",
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
                      onPressed: () {},
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
                      onPressed: () {},
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
                    Center(
                      child: Text(
                        "______________or sign up with______________",
                        style: TextStyle(
                            fontFamily: "os-semibold",
                            fontSize: 13,
                            color: Color(0xffF7DC6F)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            child: Image.asset("assets/img/google.png"),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Color(0xffE8E8E8))),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            child: Image.asset("assets/img/Facebook.png"),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Color(0xffE8E8E8)),
                            ),
                          ),
                        ],
                      ),
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
