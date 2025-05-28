import 'package:flutter/material.dart';
import 'package:hand_app/pages/Camera_detection.dart';
import 'package:hand_app/widgets/Logobar.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Logobar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CameraDetectionPage(questionText: 0),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x80DC89D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                "DAY 1",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x80DC89D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                "DAY 2",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x80DC89D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                "DAY 3",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x80DC89D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                "DAY 4",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x80DC89D1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: const Text(
                "DAY 5",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
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
