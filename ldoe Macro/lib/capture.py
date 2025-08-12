import sys
import os
import ctypes
from PIL import ImageGrab

# DPI 인식 활성화 (AHK와 좌표 일치)
try:
    ctypes.windll.user32.SetProcessDPIAware()
except:
    pass

# 경로 설정
current_dir = os.path.dirname(os.path.abspath(__file__))  # capture.py의 폴더 경로 (lib)
images_dir = os.path.join(current_dir, "images")          # images 폴더 경로
os.makedirs(images_dir, exist_ok=True)                   # images 폴더가 없으면 생성

# 좌표 입력 (x1 y1 x2 y2)
if len(sys.argv) != 5:
    print("Usage: python capture.py x1 y1 x2 y2")
    sys.exit(1)

x1, y1, x2, y2 = map(int, sys.argv[1:5])

# 화면 캡처 및 저장
output_path = os.path.join(images_dir, "num.png")     # 저장 경로: lib/images/capture.png
image = ImageGrab.grab(bbox=(x1, y1, x2, y2))
image.save(output_path)
print(f"캡처 완료: {output_path}")