import 'package:dictionary_app/input.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          shadowColor: Color.fromARGB(255, 112, 112, 204),
          backgroundColor:
              Color.fromARGB(255, 133, 239, 245), // Set the default AppBar background color here
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Focus',
      home: const Input(),
    );
  }
}
