import 'package:flutter/material.dart';
import 'package:noviindus_patients/core/theme/app_theme.dart';
import 'package:noviindus_patients/screend/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      debugShowCheckedModeBanner: false,
      theme:AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
