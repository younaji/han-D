import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hand_app/pages/Camera_detection.dart';
import 'package:hand_app/pages/answer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CameraDetectionPage(questionText: 0),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF1F1),
      body: Center(
        child: Image.asset(
          'assets/images/loading_logo.png',
          width: screenSize.width * 0.56,
        ),
      ),
    );
  }
}
