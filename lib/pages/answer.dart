import 'package:flutter/material.dart';
import 'package:hand_app/widgets/Logobar.dart';
import 'package:video_player/video_player.dart';
import 'Camera_detection.dart';

class AnswerVideo extends StatefulWidget {
  final String videoFileName;
  final int nextQuestionIndex;
  final int questionText;
  final int correctCount;

  const AnswerVideo({
    Key? key,
    required this.videoFileName,
    required this.nextQuestionIndex,
    required this.questionText,
    required this.correctCount,
  }) : super(key: key);
  @override
  _AnswerVideoState createState() => _AnswerVideoState();
}

class _AnswerVideoState extends State<AnswerVideo> {
  late VideoPlayerController _controller;

  String get questionNum => quizData[widget.questionText]['text'];
  @override
  void initState() {
    super.initState();

    final assetPath = 'assets/videos/${widget.videoFileName}';
    print("📼 Trying to load: $assetPath");

    _controller = VideoPlayerController.asset(assetPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((e) {
        print("❌ 영상 초기화 중 catchError: $e");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Logobar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
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
            Text(
              'Follow this one more time!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Column(
              children: [
                Container(
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const CircularProgressIndicator(),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Text(
                  questionNum,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraDetectionPage(
                      questionText: widget.nextQuestionIndex,
                      correctCount: widget.correctCount,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
