#Include <ButtonSaver>
#Include <MacroStart>
#Include <GetNum>

class NoxGui {
    myGui := ""  ; GUI 객체를 저장할 필드

    ShowGui() {
        this.myGui := Gui("+AlwaysOnTop", "매크로 실행")
        this.myGui.SetFont("s10", "Segoe UI")

        ; Start Macro 버튼
        btnStart := this.myGui.Add("Button", "w120 h40", "Start Macro")
        btnStart.OnEvent("Click", ObjBindMethod(this, "OnStartMacro"))

        ; 버튼 재지정 버튼 (옆에 배치)
        btnSetKey := this.myGui.Add("Button", "x+10 w120 h40", "버튼 재지정")
        btnSetKey.OnEvent("Click", ObjBindMethod(this, "OnRebindButton"))

        ; 왼쪽 가격 보여주기
        btnLeft := this.myGui.Add("Button", "xm w120 h40", "왼쪽 가격")
        btnLeft.OnEvent("Click", ObjBindMethod(this, "OnShowPriceLeft"))

        ; 오른쪽 가격 보여주기
        btnRight := this.myGui.Add("Button", "x+10 w120 h40", "오른쪽 가격")
        btnRight.OnEvent("Click", ObjBindMethod(this, "OnShowPriceRight"))

        this.myGui.Show()
    }

    ; 매크로 시작 실행
    OnStartMacro(*) {
        StartMacro()
    }

    ; 버튼 재지정 실행
    OnRebindButton(*) {
        StartButtonSave()
    }

    OnShowPriceLeft(*) {
        this.ShowPriceRect("nox_1")
    }

    OnShowPriceRight(*) {
        this.ShowPriceRect("nox_2")
    }

    ShowPriceRect(prefix) {
        try {
            global saveManager  ; NoxWindowManager 인스턴스 (예: noxMgr := NoxWindowManager())

            ; 좌상단 / 우하단 좌표 읽기 → [x,y]
            posL := saveManager.GetXY(prefix "_PriceLeft")
            posR := saveManager.GetXY(prefix "_PriceRight")

            ; 직사각형 정규화
            x1 := Min(posL[1], posR[1]), y1 := Min(posL[2], posR[2])
            x2 := Max(posL[1], posR[1]), y2 := Max(posL[2], posR[2])

            ; 너무 작은 영역 방지(선택)
            if (x2 - x1 < 2 || y2 - y1 < 2)
                throw Error("OCR 영역이 너무 작습니다. PriceLeft/Right를 다시 저장하세요.")

            ; 한 번만 OCR
            num := CaptureAndRecognizeNumber([x1, y1, x2, y2])

            ; 출력
            MsgBox prefix ": " num, "가격 확인"
        } catch as e {
            MsgBox "가격 표시 실패: " e.Message
        }
    }

    
}