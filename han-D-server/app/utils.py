import torch
import torch.nn.functional as F
from .config import param

def predict_sequence(model, input_sequence, threshold=0.6):
    x = torch.tensor(input_sequence, dtype=torch.float32).unsqueeze(0)  # (1, 60, 138)
    x = x.to(param['device'])

    with torch.no_grad():
        logits = model(x)                      # (1, n_classes)
        probs = F.softmax(logits, dim=1)       # 확률화
        confidence, pred_idx = torch.max(probs, dim=1)  # 최고 확률과 인덱스

        if confidence.item() < threshold:
            return "class_10"  # 확률이 낮을 경우 특수 클래스
        else:
            return param['class_names'][pred_idx.item()]