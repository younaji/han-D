import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraDetectionPage extends StatefulWidget {
  const CameraDetectionPage({super.key});

  @override
  State<CameraDetectionPage> createState() => _CameraDetectionPageState();
}

class _CameraDetectionPageState extends State<CameraDetectionPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _hasCamera = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: screenSize.height * 0.1),

          // 제목
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

          SizedBox(height: screenSize.height * 0.05),

          Expanded(
            child: _hasCamera
                ? (_isCameraInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color(0xFFB39DDB),
                          ),
                          AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          ),
                          const Positioned(
                            top: 20,
                            child: Text(
                              '이 수화 단어를 맞춰보세요',
                              style: TextStyle(
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
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ElevatedButton(
              onPressed: _hasCamera
                  ? () {
                      print("Continue pressed");
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A5C),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
            ),
          ),
        ],
      ),
    );
  }
}
