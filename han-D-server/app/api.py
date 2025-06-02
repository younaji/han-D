from fastapi import APIRouter, UploadFile, File
import os, uuid, shutil
from .model import load_model
from .utils import predict_sequence
from .video_utils import extract_kpnet_input_from_video

router = APIRouter()
model = load_model()

@router.post("/predict_video/")
async def predict_video(file: UploadFile = File(...)):
    temp_filename = f"temp_{uuid.uuid4().hex}.avi"
    temp_path = os.path.join("temp_videos", temp_filename)
    os.makedirs("temp_videos", exist_ok=True)
    with open(temp_path, "wb") as f:
        shutil.copyfileobj(file.file, f)

    try:
        sequence = extract_kpnet_input_from_video(temp_path)
    except Exception as e:
        os.remove(temp_path)
        return {"error": str(e)}

    prediction = predict_sequence(model, sequence)
    os.remove(temp_path)
    return {"prediction": prediction}
