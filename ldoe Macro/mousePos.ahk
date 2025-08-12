#Requires AutoHotkey v2.0
CoordMode "Mouse", "Screen"  ; 화면 전체 기준

F1::  ; F1 누르면 좌표 표시
{
    MouseGetPos &x, &y
    ToolTip "X: " x "  Y: " y, 0, 0
    Sleep 1000
    ToolTip  ; 1초 후 툴팁 제거
}

F2::ExitApp  ; F2로 종료
