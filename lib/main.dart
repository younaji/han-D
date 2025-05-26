import 'package:flutter/material.dart';
import 'package:hand_app/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Han:D',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
