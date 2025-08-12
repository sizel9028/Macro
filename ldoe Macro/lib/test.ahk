#Requires AutoHotkey v2.0

; (선택) 작업 폴더: 스크립트 기준이면 편함
SetWorkingDir A_ScriptDir

; 파이썬 실행 커맨드 (네 PC에 py 런처 있으면 권장)
py := "py -3"                  ; 없으면 "python" 또는 절대경로
script := A_ScriptDir "\image.py"

EnvSet("PYTHONIOENCODING", "utf-8")  ; 한글/버퍼 꼬임 방지
cmd := py ' -u "' script '"'

try {
    shell := ComObject("WScript.Shell")
    exec  := shell.Exec(cmd)

    ; 실행 완료 대기
    while exec.Status = 0
        Sleep 10

    out := exec.StdOut.ReadAll()
    err := exec.StdErr.ReadAll()

    if (Trim(err) != "")
        MsgBox "에러:`n" err, "OCR 에러", "Icon!"
    else
        MsgBox "인식 결과: " Trim(out), "OCR 완료", "Iconi"
} catch as e {
    MsgBox "실행 오류: " e.Message, "에러", "Icon!"
}
