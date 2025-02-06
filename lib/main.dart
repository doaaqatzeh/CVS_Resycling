import 'package:cvsr/login_page.dart';
import 'package:cvsr/main_page.dart';
import 'package:cvsr/welcom_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_page.dart';
import 'thank_you_page.dart';
import 'verify_email_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CVS Recycling',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: MainPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomPage(),
        '/thankyou': (context) => ThankYouPage(),
        '/verifyemail': (context) => VerifyEmailPage(email: ''),
        '/regesitration': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => MainPage(),
      },
    );
  }
}
