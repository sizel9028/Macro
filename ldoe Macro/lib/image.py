from pathlib import Path
import cv2, pytesseract, sys

# Tesseract 경로 설정 (필요시 수정)
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

def recognize_digits(image_path):
    """이미지에서 숫자 추출"""
    try:
        img = cv2.imread(str(image_path), cv2.IMREAD_GRAYSCALE)
        if img is None:
            return "[ERROR] 이미지 불러오기 실패"

        # 숫자 전용 OCR 설정
        config = r"-l eng --oem 3 --psm 7 -c tessedit_char_whitelist=0123456789"
        text = pytesseract.image_to_string(img, config=config)
        return "".join(filter(str.isdigit, text)) or "숫자 미검출"
    except Exception as e:
        return f"[ERROR] {str(e)}"

if __name__ == "__main__":
    BASE = Path(__file__).resolve().parent
    IMG_PATH = BASE / "images" / "num.PNG"  # capture.py와 동일한 경로
    
    result = recognize_digits(IMG_PATH)
    print(result)  # AHK에서 결과 캡처용