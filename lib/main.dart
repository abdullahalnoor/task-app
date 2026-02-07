import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        primaryColor: const Color(0xFF22C55E),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
