import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hand_app/pages/answer.dart';
import 'package:hand_app/widgets/Logobar.dart';
import 'package:hand_app/pages/correct_answer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<Map<String, dynamic>> quizData = [
  {'text': '화요일', 'index': 521},
  {'text': '친구', 'index': 470},
  {'text': '작년', 'index': 432},
  {'text': '왼쪽', 'index': 393},
  {'text': '오른쪽', 'index': 387},
  {'text': '오늘', 'index': 386},
  {'text': '병원', 'index': 257},
  {'text': '바다', 'index': 237},
  {'text': '내일', 'index': 181},
  {'text': '개', 'index': 128}
];

class CameraDetectionPage extends StatefulWidget {
  final int questionText;

  const CameraDetectionPage({
    super.key,
    required this.questionText,
  });

  @override
  State<CameraDetectionPage> createState() => _CameraDetectionPageState();
}

class _CameraDetectionPageState extends State<CameraDetectionPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _hasCamera = true;
  XFile? _videoFile;
  bool _isRecordingStarted = false;

  String get questionNum => quizData[widget.questionText]['text'];
  int get questionIndex => quizData[widget.questionText]['index'];

  @override
  void initState() {
    super.initState();
    _initCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        print("No camera found on this device.");
        setState(() {
          _hasCamera = false;
          _isCameraInitialized = false;
        });
        return;
      }

      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController =
          CameraController(selectedCamera, ResolutionPreset.medium);

      await _cameraController!.initialize();

      setState(() {
        _hasCamera = true;
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Camera initialization error: $e");
      setState(() {
        _hasCamera = false;
        _isCameraInitialized = false;
      });
    }
  }

  Future<void> startRecording() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      await _cameraController!.startVideoRecording();
      print("녹화 시작");
    }
  }

  Future<void> stopRecording() async {
    if (_cameraController != null &&
        _cameraController!.value.isRecordingVideo) {
      final file = await _cameraController!.stopVideoRecording();
      print("녹화 완료: ${file.path}");
      setState(() {
        _videoFile = file;
      });
    }
  }

  Future<void> sendVideoToServer() async {
    if (_videoFile == null) return;

    final uri = Uri.parse("http://192.168.0.10:8000/predict_video/");
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _videoFile!.path));

    final response = await request.send();
    final result = await response.stream.bytesToString();
    final data = jsonDecode(result); // JSON 객체로 파싱
    final predictedClassName = data['prediction']; // "class_2"
    print("서버 예측 결과: $predictedClassName");

    // 정답 또는 오답 페이지
    int nextIndex = (widget.questionText + 1) % quizData.length;
    if (nextIndex >= quizData.length) nextIndex = 0;
    if (predictedClassName == "class_${questionIndex}") {
      // 정답인 경우
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CorrectAnswerPage(nextQuestionIndex: nextIndex),
        ),
      );
    } else {
      // 오답인 경우
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AnswerVideo(
            videoFileName: "$questionIndex.mp4",
            nextQuestionIndex: nextIndex,
            questionText: widget.questionText,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Logobar(),
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                questionNum,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                '  을/를 수어로 표현하세요',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0x80DC89D1),
                ),
              ),
            ],
          ),
          Expanded(
            child: _hasCamera
                ? (_isCameraInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: screenSize.width * 0.89,
                            height: screenSize.height * 0.5,
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
                            child: AspectRatio(
                              aspectRatio: _cameraController!.value.aspectRatio,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()))
                : const Center(
                    child: Text(
                      '카메라를 사용할 수 없습니다.\n기기를 확인해주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end, // ⭐️ 버튼 하단 맞춤
              children: [
                SizedBox(width: screenSize.width * 0.1),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end, // ⭐️ 아래 정렬
                  children: [
                    SizedBox(
                      height: 20,
                      child: _isRecordingStarted
                          ? const Text(
                              'Recording...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 130,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: (_hasCamera && !_isRecordingStarted)
                            ? () async {
                                setState(() {
                                  _isRecordingStarted = true;
                                });
                                await startRecording();
                              }
                            : null,
                        icon: Icon(
                          _isRecordingStarted
                              ? Icons.videocam
                              : Icons.fiber_manual_record,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Record',
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: screenSize.width * 0.1),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end, // ⭐️ 아래 정렬
                  children: [
                    SizedBox(
                      width: 130,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _hasCamera
                            ? () async {
                                await stopRecording();
                                await sendVideoToServer();
                              }
                            : null,
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x80DC89D1),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
