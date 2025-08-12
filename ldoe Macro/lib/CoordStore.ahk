class NoxWindowManager {
    NOX_EXE   := "Nox.exe"
    INI_FILE  := A_ScriptDir "\pos.ini"
    SECTION   := "Positions"

    SaveToIni(name := "Default") {
        ;CoordMode("Mouse", "Screen") ; 화면 기준 좌표
        MouseGetPos(&x, &y)
        IniWrite(x, this.INI_FILE, this.SECTION, "X_" name)
        IniWrite(y, this.INI_FILE, this.SECTION, "Y_" name)
        ToolTip("마우스 좌표 저장: " name " (" x ", " y ")", 10, 10)
        SetTimer(() => ToolTip(), -800)
    }


    LoadFromIni(name := "Default") {
        try {
            x := IniRead(this.INI_FILE, this.SECTION, "X_" name, "")
            y := IniRead(this.INI_FILE, this.SECTION, "Y_" name, "")
        } catch {
            x := ""
            y := ""
        }

        if (x = "" || y = "") {
            MsgBox("저장된 좌표가 없습니다: " name "`n현재 마우스 좌표를 저장합니다.")
            this.SaveToIni(name)
            ; 저장 후 다시 불러오기
            return this.LoadFromIni(name)
        }

        CoordMode("Mouse", "Screen")
        MouseMove(x, y, 0)
        MouseClick("left")  ; 클릭 추가
        ToolTip("좌표 불러오기: " name " (" x ", " y ")", 10, 10)
        SetTimer(() => ToolTip(), -800)
    }

    ; === 좌표 표준화: name -> [x, y] 반환 (없으면 저장 유도 후 재시도) ===
    GetXY(name := "Default") {
        x := IniRead(this.INI_FILE, this.SECTION, "X_" name, "")
        y := IniRead(this.INI_FILE, this.SECTION, "Y_" name, "")

        if (x = "" || y = "") {
            ; 좌표가 없으면 즉시 저장 유도 후 재시도
            MsgBox("저장된 좌표가 없습니다: " name "`n현재 마우스 좌표를 저장합니다.")
            this.SaveToIni(name)
            x := IniRead(this.INI_FILE, this.SECTION, "X_" name, "")
            y := IniRead(this.INI_FILE, this.SECTION, "Y_" name, "")
            if (x = "" || y = "")
                throw Error("좌표 읽기 실패: " name)
        }
        return [Integer(x), Integer(y)]
    }

}
