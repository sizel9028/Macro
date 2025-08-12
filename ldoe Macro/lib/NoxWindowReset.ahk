; ===== lib/NoxWindowReset.ahk =====
; AutoHotkey v2
; Nox 및 멀티 인스턴스 매니저 위치 초기화 

class NoxWindowReset {
    static NOX_EXE := "Nox.exe"
    static NOX_CLASS := "Qt5QWindowIcon"
    static resizedMap := Map() ; hwnd별 적용 여부 저장

    static ResetAllNox() {
        list := WinGetList("ahk_exe " this.NOX_EXE " ahk_class " this.NOX_CLASS)
        if list.Length = 0 {
            MsgBox "Nox 창을 찾지 못했습니다."
            return 0
        }

        MonitorGetWorkArea(1, &L, &T, &R, &B)
        cols := (list.Length >= 2) ? 2 : 1
        cellW := Floor((R - L) / cols)

        i := 0
        for hwnd in list {
            col := Mod(i, cols)
            x := L + (col * cellW)
            y := T

            ; 위치 이동
            this._moveByHwnd(hwnd, x, y)

            ; 이 hwnd가 처음이라면 크기 축소
            if !this.resizedMap.Has(hwnd) {
                WinGetPos(&cx, &cy, &cw, &ch, "ahk_id " hwnd)
                newW := Floor(cw * 0.8)
                newH := Floor(ch * 0.8)
                WinMove(cx, cy, newW, newH, "ahk_id " hwnd) ; 위치는 그대로, 크기만 변경
                this.resizedMap[hwnd] := true
            }

            i++
        }

        return list.Length
    }

    static _moveByHwnd(hwnd, x, y) {
        WinMove x, y,,, "ahk_id " hwnd
    }
}