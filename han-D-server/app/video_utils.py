import cv2
import numpy as np
import mediapipe as mp

def extract_kpnet_input_from_video(video_path: str) -> np.ndarray:
    time_steps = 60
    H, W = 224, 224  # 훈련 시 설정한 사이즈

    mp_pose = mp.solutions.pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5)
    mp_hands = mp.solutions.hands.Hands(min_detection_confidence=0.5, min_tracking_confidence=0.5, max_num_hands=2)

    # 프레임 추출
    cap = cv2.VideoCapture(video_path)
    frames = []
    while True:
        ret, frm = cap.read()
        if not ret:
            break
        frames.append(frm)
    cap.release()

    if len(frames) == 0:
        raise ValueError("비디오에서 프레임을 추출할 수 없습니다.")

    # 60프레임 샘플링
    if len(frames) < time_steps:
        raise ValueError("프레임이 60개 이상 필요합니다.")
    idxs = np.linspace(0, len(frames)-1, time_steps, dtype=int)

    sequence = []
    for i in idxs:
        img = cv2.resize(frames[i], (W, H))
        rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        p_res = mp_pose.process(rgb)
        h_res = mp_hands.process(rgb)

        coords = []
        if p_res.pose_landmarks:
            for j in (11, 13, 12, 14):
                lm = p_res.pose_landmarks.landmark[j]
                coords += [lm.x, lm.y, lm.z]
        else:
            coords += [0.0] * 12

        hands = (h_res.multi_hand_landmarks or [])[:2]
        for hand in hands:
            for lm in hand.landmark:
                coords += [lm.x, lm.y, lm.z]
        if len(hands) == 0:
            coords += [0.0] * 126
        elif len(hands) == 1:
            coords += [0.0] * 63

        # 어깨 중심 정규화
        cx = (coords[0] + coords[6]) * 0.5
        cy = (coords[1] + coords[7]) * 0.5
        sc = np.hypot(coords[6] - coords[0], coords[7] - coords[1]) + 1e-6
        for t in range(0, len(coords), 3):
            coords[t] = (coords[t] - cx) / sc
            coords[t+1] = (coords[t+1] - cy) / sc

        sequence.append(coords)

    return np.array(sequence, dtype=np.float32)  # (60, 138)