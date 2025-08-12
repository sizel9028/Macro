#SingleInstance Force
#Requires AutoHotkey v2.0

#Include <CoordStore>
#Include <NoxWindowReset>
#Include <NoxGui>

CoordMode("Mouse", "Screen")

global saveManager := NoxWindowManager()

; GUI 실행
guiApp := NoxGui()    ; 인스턴스 생성
guiApp.ShowGui()      ; 창 띄우기

; F1 = 화면 셋팅
F1::{
    ; 위치 리셋
    NoxWindowReset.ResetAllNox()
}

; F12 = 매크로 종료
F12:: {
    ExitApp
}
