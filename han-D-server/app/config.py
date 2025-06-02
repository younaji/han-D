# 모델 및 클래스 설정
import torch

param = {
    "model_path": "models/best.pt",
    "time_steps": 60,
    "feat_dim": 138,
    "n_classes": 524,
    "device": "cuda" if torch.cuda.is_available() else "cpu",
    "class_names": [f"class_{i}" for i in range(524)],
}