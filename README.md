# 2025-Spring Deep Learning Team Project - Han:D 👋

## Han:D
- **Han:D** is a sign-language study app using Deep Learning technology!
- It assists sign language learning by recognizing the user's hand movements in real time.

## Features
- Extracting frames and keypoint features from user images
- Classification of sign language classes using LSTM-based deep learning model
- Deal with exceptions if the reliability is below the threshold value
- Provides Fast API that works with the Flutter

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🍏 Front-End

### Tech Stack
- flutter : 3.32.0
- dart : 3.8.0
- camera : 0.10.5+5
- video_player : 2.9.5
- http : 0.13.6

### Hierarchy

```
app
├── ios
│ └── Podfile
├── assets
│ ├── images
│ └── videos
├── lib
│ ├── auth
│ ├── pages
│ └── widgets
├── main.dart
└── pubspec.yaml
```

### Demo
- Install Flutter and Simulator (This code is focused on ios App)
- Install environments
```
flutter pub get
```
- Start debugging in 'main.dart' file
```
flutter run
```

<div align="center">
  <img src="assets/videos/T04_video.gif" alt="Logo" width="250"/>
</div>

## 🚀 Back-End

## API Usage

- **Request**:
  `file`: `.mp4` styled video
  
- **Response Example**:
```json
{
"prediction": "class_3"
}
```

## How to Run

**1. Install**
```
pip install -r requirements.txt
```

**2. Server run**
```
uvicorn app.main:app --reload
```

## 🧠 AI

- **Input**: `(1, 60, 138)`  
(60 frames, 3D coordinates of 46 joints per frame)

- **Architecture**:
  LSTM (138 → 128)
→ BatchNorm1d(128)
→ LSTM (128 → 128)
→ Linear (128 → 64)
→ Dropout (p=0.3)
→ Linear (64 → num_classes)

- **Output**: `logits.shape = (1, n_classes)` → softmax probability distribution

  ## 🧑‍💻 Contributors
| Name  | Role               |
| --- | ----------------- |
| 최정은 | Deep Learning Model Development |
| 김도희 | Model Interworking and Backend Development |
| 지유나 | App Demo Development |
