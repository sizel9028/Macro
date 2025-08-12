import sys
import cv2
import pyautogui
import numpy as np
import os

def main():
    try:
        # 하드코딩된 이미지 이름
        image_name = "cap.png"  # 여기에 이미지 이름을 하드코딩

        # 1. 이미지 경로 생성 (images 폴더 하위)
        image_path = os.path.join("images", image_name)
        
        if not os.path.exists(image_path):
            print(0, file=sys.stdout)  # 실패 값
            return

        # 2. 화면 캡처 + 이미지 매칭
        screen = np.array(pyautogui.screenshot())
        template = cv2.imread(image_path)
        
        if template is None:
            print(0, file=sys.stdout)  # 실패 값
            return

        result = cv2.matchTemplate(
            cv2.cvtColor(screen, cv2.COLOR_RGB2BGR),
            template,
            cv2.TM_CCOEFF_NORMED
        )
        _, max_val, _, _ = cv2.minMaxLoc(result)
        
        # 매칭 성공 시 "1", 실패 시 "0"
        if max_val > 0.7:
            print(1, file=sys.stdout)  # 이미지 매칭 성공 시 1 반환
        else:
            print(0, file=sys.stdout)  # 이미지 매칭 실패 시 0 반환

    except Exception as e:
        print(0, file=sys.stdout)  # 오류 발생 시 0 반환
        print(f"Error: {e}", file=sys.stdout)

if __name__ == "__main__":
    main()
