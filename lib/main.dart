import 'package:flutter/material.dart';
import 'package:hand_app/auth/splash_screen.dart';

final Map<String, String> classToVideo = {
  'class_0': '4.mp4',
  'class_1': '1.mp4',
  'class_2': '2.mp4',
  'class_3': '3.mp4',
  'class_4': '5.mp4',
};

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
