import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hand_app/pages/answer.dart';
import 'package:hand_app/widgets/Logobar.dart';
import '../pages/predictor.dart';

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
  late Predictor predictor;

  String get questionNum => quizData[widget.questionText]['text'];
  int get questionIndex => quizData[widget.questionText]['index'];

  @override
  void initState() {
    super.initState();
    _initCamera();
    predictor = Predictor();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await predictor.loadModel();
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

  Future<void> runPrediction(
      List<List<double>> inputData, int questionIndex) async {
    int predictedIndex = await predictor.predict(inputData);

    if (predictedIndex == questionIndex) {
      print("✅ 정답입니다!");
    } else {
      print("❌ 오답입니다. 정답: $questionIndex, 예측: $predictedIndex");
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
                      ? () {
                          print("녹화 시작");
                        }
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
                          print("녹화 끝");
                          await Future.delayed(const Duration(seconds: 2));
                          if (widget.questionText < quizData.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CameraDetectionPage(
                                    questionText: widget.questionText + 1),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AnswerVideo(
                                  videoFileName: '1.mp4',
                                ),
                              ),
                            );
                          }
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
