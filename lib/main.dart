import 'package:flutter/material.dart';
import 'package:mediaplayerapp/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Media Player",
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        fontFamily: "regular",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const Home(),
    );
  }
}
