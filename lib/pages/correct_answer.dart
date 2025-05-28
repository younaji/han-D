import 'package:flutter/material.dart';
import 'package:hand_app/widgets/Logobar.dart';
import 'Camera_detection.dart'; // 다음 문제로 이동

class CorrectAnswerPage extends StatelessWidget {
  final int nextQuestionIndex;

  const CorrectAnswerPage({super.key, required this.nextQuestionIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Logobar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '정답입니다!',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraDetectionPage(
                      questionText: nextQuestionIndex,
                    ),
                  ),
                );
              },
              child: const Text("다음 문제"),
            )
          ],
        ),
      ),
    );
  }
}
