import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math';

class Predictor {
  late final Interpreter _interpreter;
  bool _isLoaded = false;

  /// 모델 로드 (앱 시작 시 한 번만 호출)
  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('lib/assets/model/kpnet.tflite');
      _isLoaded = true;
      print("모델 로딩 완료");
    } catch (e) {
      print("모델 로딩 실패: $e");
    }
  }

  /// 입력: [60][138] float 리스트 → 예측된 클래스 인덱스 반환
  Future<int> predict(List<List<double>> input) async {
    if (!_isLoaded) {
      throw Exception("모델이 아직 로딩되지 않았습니다. loadModel() 먼저 호출하세요.");
    }

    final inputTensor = [input]; // shape: [1, 60, 138]
    final outputTensor =
        List.generate(1, (_) => List.filled(5, 0.0)); // shape: [1, 5]

    _interpreter.run(inputTensor, outputTensor);

    final prediction = outputTensor[0];
    final predictedIndex = prediction.indexOf(prediction.reduce(max));

    print("예측 결과 (raw): $prediction");
    print("예측 인덱스: $predictedIndex");

    return predictedIndex;
  }

  /// 리소스 정리 (필요 시)
  void close() {
    _interpreter.close();
    _isLoaded = false;
  }
}
