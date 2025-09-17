import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "lib/assets/images/splash_novi.png", 
            fit: BoxFit.cover,
          ),
          // Overlay with logo
          // Center(
          //   child: Image.asset(
          //     "assets/images/logo.png", // your PNG logo in center
          //     height: 120,
          //     width: 120,
          //   ),
          // ),
        ],
      ),
    );
  }
}
