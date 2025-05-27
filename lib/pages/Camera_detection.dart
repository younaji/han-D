import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hand_app/pages/answer.dart';
import 'package:hand_app/widgets/Logobar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<Map<String, dynamic>> quizData = [
  {'text': '선반', 'index': 0},
  {'text': '기절하다', 'index': 1},
  {'text': '남편', 'index': 2},
  {'text': '빨리 도와주세요', 'index': 3},
  {'text': '협박', 'index': 4}
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

  String get questionNum => quizData[widget.questionText]['text'];
  int get questionIndex => quizData[widget.questionText]['index'];

  @override
  void initState() {
    super.initState();
    _initCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
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
    if (_cameraController != null && _cameraController!.value.isRecordingVideo) {
      final file = await _cameraController!.stopVideoRecording();
      print("녹화 완료: ${file.path}");
      setState(() {
        _videoFile = file;
      });
    }
  }

  Future<void> sendVideoToServer() async {
    if (_videoFile == null) return;

    final uri = Uri.parse("http://127.0.0.1:8000/predict_video/");
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _videoFile!.path));

    final response = await request.send();
    final result = await response.stream.bytesToString();
    final data = jsonDecode(result);
    print("서버 예측 결과: ${data['prediction']}");

    // 정답 또는 오답 페이지
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
          const Text(
            'DAY 1',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Color(0xFF302E2E),
            ),
          ),
          Expanded(
            child: _hasCamera
                ? (_isCameraInitialized
                    ? Stack(
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
                            child: AspectRatio(
                              aspectRatio: _cameraController!.value.aspectRatio,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                          Positioned(
                            bottom: 60,
                            child: Text(
                              questionNum,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
              child: Row(children: [
                SizedBox(width: screenSize.width * 0.1),
                ElevatedButton(
                  onPressed: _hasCamera
                      ? startRecording
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x80DC89D1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    'Record',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.1),
                ElevatedButton(
                  onPressed: _hasCamera
                      ? () async {

                    await stopRecording();
                    await sendVideoToServer();
                  }

                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x80DC89D1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ])),
        ],
      ),
    );
  }
}
