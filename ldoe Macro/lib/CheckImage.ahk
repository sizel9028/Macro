#Requires AutoHotkey v2.0

IsJackPot() {
    ; === 파이썬 스크립트 경로 ===
    python_script := A_ScriptDir "\lib\SearchImage.py"  ; AHK와 같은 lib 폴더 내 Python 스크립트 경로
    
    ; === Python 실행 명령어 ===
    py := "python"  ; py -3 대신 python으로 변경 (확인 필요)
    
    ; 명령어 조합 (경로에 공백이 있을 경우를 대비해 따옴표로 감싸기)
    cmd := '"' py '" "' python_script '"'
    
    ; === WScript.Shell을 사용하여 명령어 실행 ===
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(cmd)  ; Python 스크립트를 실행
    
    ; 대기 (출력 결과가 올 때까지)
    while exec.Status = 0
        Sleep 50  ; 대기 시간 조정 (출력 결과가 올 때까지 기다림)

    ; 결과 처리
    out := Trim(exec.StdOut.ReadAll())
    out := StrReplace(out, "`r")       ; 캐리지 리턴 제거
    out := StrReplace(out, "`n")       ; 개행 문자 제거

    error := exec.StdErr.ReadAll()

    ; 디버깅 메시지
    ;MsgBox "Raw stdout: " out "`nstderr: " error

    ; 오류 처리
    if (error != "") {
        MsgBox "에러:`n" error, "OCR 에러", "Icon!"
        FileAppend "[" A_Now "] ERROR: " error "`n", A_ScriptDir "\error.log"
        return false
    }

    ; 값 정제
    out := Trim(out)  ; 공백 제거
    
    ; Python에서 반환한 값에 따라 처리
    if (out = "1" or out = "True") {
        return true
    }
    else {
        return false
    }
}

