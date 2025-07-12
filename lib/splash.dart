import 'dart:async';

import 'package:day_12/home.dart';
import 'package:day_12/login.dart';
import 'package:day_12/share_preferences.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  static const String KEYNAME = "Login";
  static const String USERKEY = "USER";
  @override
  void initState() {
    super.initState();
    wheretogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(0, 5),
              )
            ],
          ),
          width: 300,
          height: 300,
          child: const Center(
            child: Text("Splash Screen",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void wheretogo() async {
    await LocalStorage.initialize();
    LocalStorage.getString(USERKEY);
    var isLoggedIn = LocalStorage.getBool(KEYNAME);
    Timer(
      const Duration(seconds: 2),
      () {
        if (isLoggedIn != null) {
          if (isLoggedIn) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        }
      },
    );
  }
}
