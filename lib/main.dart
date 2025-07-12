import 'package:day_12/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.red,
          appBarTheme: const AppBarTheme(
            color: Colors.orange,
            titleTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          )),
      home: const Splash(),
    );
  }
}
