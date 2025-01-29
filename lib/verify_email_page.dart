import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;

  VerifyEmailPage({required this.email});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  bool _isEmailVerified = false;
  bool _isLoading = false;
  String _message = '';
  bool _isVerificationEmailSent = false;

  @override
  void initState() {
    super.initState();
    _checkInitialEmailVerification();
    _loadVerificationEmailStatus();
    _saveCurrentPage();
  }

  Future<void> _checkInitialEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      setState(() {
        _isEmailVerified = true;
      });
    }
  }

  Future<void> _loadVerificationEmailStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVerificationEmailSent =
          prefs.getBool('isVerificationEmailSent') ?? false;
    });
  }

  Future<void> _saveVerificationEmailStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVerificationEmailSent', status);
  }

  Future<void> _saveCurrentPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentPage', '/verifyemail');
  }

  // @override
  // Widget build(BuildContext context) {
  //   final String email = widget.email;

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Verify Your Email'),
  //       centerTitle: true,
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ),
  //     body: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               'Please verify your email address: $email',
  //               style: TextStyle(fontSize: 18),
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: _isLoading ? null : () => _handleButtonPress(context, email),
  //               child: _isLoading
  //                   ? CircularProgressIndicator(color: Colors.white)
  //                   : Text(_isEmailVerified ? 'Continue' : 'Send Verification Email'),
  //               style: ElevatedButton.styleFrom(
  //                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //               ),
  //             ),
  //             if (_message.isNotEmpty)
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 20),
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //                   color: _isEmailVerified ? Colors.blue : Colors.green,
  //                   child: Text(
  //                     _message,
  //                     style: TextStyle(color: Colors.white, fontSize: 16),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _handleButtonPress(BuildContext context, String email) async {
  //   if (_isEmailVerified) {
  //     Navigator.pushReplacementNamed(context, '/thankyou', arguments: FirebaseAuth.instance.currentUser?.displayName);
  //   } else {
  //     if (!_isVerificationEmailSent) {
  //       await _sendVerificationEmail(context, email);
  //     }
  //     await _checkEmailVerified(context);
  //   }
  // }

  Future<void> _sendVerificationEmail(
      BuildContext context, String email) async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          _message =
              'Verification link sent to $email. Please check your inbox!';
          _isVerificationEmailSent = true;
        });
        await _saveVerificationEmailStatus(true);

        // Hide the message after 5 seconds
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            _message = '';
          });
        });
      } else {
        setState(() {
          _message = 'Email is already verified!';
        });
        Navigator.pushReplacementNamed(context, '/thankyou',
            arguments: user?.displayName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification email: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkEmailVerified(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      setState(() {
        _isEmailVerified = true;
        _message = 'Email verified successfully!';
      });
      Navigator.pushReplacementNamed(context, '/thankyou',
          arguments: user.displayName);
    } else {
      setState(() {
        _message = 'Email not verified yet. Please check your inbox.';
      });
    }
  }
}
