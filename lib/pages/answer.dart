import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CorrectAnswerVideo extends StatefulWidget {
  final String videoFileName;

  const CorrectAnswerVideo({Key? key, required this.videoFileName})
      : super(key: key);

  @override
  _CorrectAnswerVideoState createState() => _CorrectAnswerVideoState();
}

class _CorrectAnswerVideoState extends State<CorrectAnswerVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final fileName = widget.videoFileName;
    if (fileName.isEmpty) {
      print("❌ videoFileName is empty!");
      return;
    }

    final assetPath = 'assets/videos/$fileName';
    print("📼 Trying to load: $assetPath");

    try {
      _controller = VideoPlayerController.asset(assetPath)
        ..initialize().then((_) {
          print("✅ 영상 초기화 성공!");
          setState(() {});
          _controller.play();
        }).catchError((e) {
          print("❌ 영상 초기화 중 catchError: $e");
        });
    } catch (e) {
      print("❌ try-catch에서 실패: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
