import 'package:flutter/material.dart';
import 'package:hand_app/pages/list.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final totalQuestions = 6;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        backgroundColor: const Color(0x80DC89D1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "수어 퀴즈 완료!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "총 $totalQuestions문제 중",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "$score개 맞췄습니다 🎉",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ListPage(),
                  ),
                );
              },
              child: const Text("처음으로 돌아가기"),
            )
          ],
        ),
      ),
    );
  }
}
