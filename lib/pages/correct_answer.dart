import 'package:flutter/material.dart';
import 'package:hand_app/widgets/Logobar.dart';
import 'Camera_detection.dart'; // 다음 문제로 이동

class CorrectAnswerPage extends StatelessWidget {
  final int nextQuestionIndex;
  final int correctCount;
  const CorrectAnswerPage({
    Key? key,
    required this.nextQuestionIndex,
    required this.correctCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Logobar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.width * 0.4,
              height: screenSize.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0x80DC89D1),
              ),
              child: const Center(
                child: Text(
                  "DAY 1",
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            const Text(
              'Correct Answer!',
              style: TextStyle(fontSize: 30, color: Colors.green),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/correct.png',
              width: screenSize.width * 0.78,
            ),
            SizedBox(height: screenSize.height * 0.05),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraDetectionPage(
                      questionText: nextQuestionIndex,
                      correctCount: correctCount,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x80DC89D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                "Next Question",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
