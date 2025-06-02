import torch
import torch.nn as nn
from .config import param

class KPNet(nn.Module):
    def __init__(self, time_steps, feat_dim, n_classes):
        super().__init__()
        self.lstm1 = nn.LSTM(feat_dim,128,batch_first=True)
        self.bn1   = nn.BatchNorm1d(128)
        self.lstm2 = nn.LSTM(128,   128,batch_first=True)
        self.fc1   = nn.Linear(128, 64)
        self.drop  = nn.Dropout(0.3)
        self.out   = nn.Linear(64,  param['n_classes'])
    def forward(self,x):
        o,_ = self.lstm1(x); o = o[:,-1,:]
        o    = self.bn1(o); o = torch.relu(o)
        o,_ = self.lstm2(o.unsqueeze(1)); o = o[:,-1,:]
        o    = torch.relu(self.fc1(o)); o = self.drop(o)
        return self.out(o)

# 모델 로드
def load_model():
    model = KPNet(param['time_steps'], param['feat_dim'], param['n_classes'])
    model.load_state_dict(torch.load(param['model_path'], map_location=param['device']))
    model.to(param['device']).eval()
    return model
