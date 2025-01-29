// ignore_for_file: sort_child_properties_last

import 'package:cvsr/registration_page.dart';
import 'package:flutter/material.dart';

class WelcomPage extends StatefulWidget {
  const WelcomPage({super.key});

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF002F6C),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 190,
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 3, 47, 103),
                    offset: Offset(0, 4),
                    blurRadius: 100,
                  )
                ]),
                child: Image.asset(
                  "assets/img/p1.png",
                  width: 300,
                  height: 250,
                ),
              ),
              Text("CVS Recycling",
                  style: TextStyle(
                    fontFamily: "opensans",
                    fontSize: 32,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/regesitration');
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontFamily: "opensans",
                              fontSize: 20,
                              color: Color(0xFF002F6C),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(16)),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontFamily: "opensans",
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF002F6C)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    side: BorderSide(
                                        color: Color(0xFFCCCCCC), width: 2))),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(16)),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
