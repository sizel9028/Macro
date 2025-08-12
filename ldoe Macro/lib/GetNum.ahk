#Requires AutoHotkey v2.0

; === 캡처 후 OCR 인식 함수 ===
CaptureAndRecognizeNumber(capture_area) {
    ; === 파이썬 스크립트 경로 ===
    python_scripts := [
        A_ScriptDir "\lib\capture.py",
        A_ScriptDir "\lib\image.py"
    ]

    ; === 캡처는 RunWait ===
    try {
        ; 1) 캡처 (사용자 지정 영역)
        RunWait('python "' python_scripts[1] '" ' capture_area[1] ' ' capture_area[2] ' ' 
              . capture_area[3] ' ' capture_area[4],, "Hide")

        ; 2) OCR (숫자 인식)
        EnvSet("PYTHONIOENCODING", "utf-8")
        py := "py -3"   ; 없으면 "python"으로 바꿔
        cmd := py ' -u "' python_scripts[2] '"'

        shell := ComObject("WScript.Shell")
        exec  := shell.Exec(cmd)

        ; 대기 (출력 결과가 올 때까지)
        while exec.Status = 0
            Sleep 10

        ; 결과 처리
        out := Trim(exec.StdOut.ReadAll())
        err := Trim(exec.StdErr.ReadAll())

        if (err != "") {
            MsgBox "에러:`n" err, "OCR 에러", "Icon!"
            return ""  ; 오류 발생 시 빈 값 반환
        } else {
            ;MsgBox "인식 결과: " out, "숫자 인식", "Iconi"
            return out  ; OCR 인식 결과 반환
        }
    } catch as e {
        MsgBox "실행 오류:`n" e.Message, "에러", "Icon!"
        return ""  ; 예외 발생 시 빈 값 반환
    }
}