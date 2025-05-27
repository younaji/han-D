import 'package:flutter/material.dart';
import 'package:hand_app/widgets/Logobar.dart';
import 'package:video_player/video_player.dart';

class AnswerVideo extends StatefulWidget {
  final String videoFileName;

  const AnswerVideo({Key? key, required this.videoFileName}) : super(key: key);

  @override
  _AnswerVideoState createState() => _AnswerVideoState();
}

class _AnswerVideoState extends State<AnswerVideo> {
  late VideoPlayerController _controller;

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
            SizedBox(height: screenSize.height * 0.1),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: screenSize.width * 0.89,
                  height: screenSize.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0x80DC89D1),
                  ),
                ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
