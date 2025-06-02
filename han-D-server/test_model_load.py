# test_model_load.py
import torch
from app.model import load_model
from app.config import param

# 1. 모델 로드
model = load_model()

# 2. 더미 입력 생성 (batch_size=1, time_steps=60, feat_dim=138)
dummy_input = torch.randn(1, param["time_steps"], param["feat_dim"]).to(param["device"])

# 3. 예측 실행
with torch.no_grad():
    output = model(dummy_input)

# 4. 출력 결과 확인
print("✅ Output shape:", output.shape)  # (1, n_classes) 이어야 정상
print("🔢 Top 5 logits:", output[0].topk(5))
