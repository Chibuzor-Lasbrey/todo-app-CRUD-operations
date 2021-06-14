import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_database_example/auth_screens/signin_page.dart';
import 'package:sqflite_database_example/page/notes_page.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      if (auth.currentUser == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NotesPage()),
            (route) => false);
      }
    });
    return Scaffold(
        body: AnimatedSplashScreen(
      splash: "assets/images/logo.jpg",
      splashTransition: SplashTransition.slideTransition,
      backgroundColor: Colors.black,
      animationDuration: Duration(seconds: 8),
      nextScreen: SignInPage(),
    ));
  }
}
