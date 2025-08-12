global saveManager
global tooltipText := ""
global tooltipTimer := 0

buttonList := [
    ; 녹스 1번 버튼들
    { name: "nox_1_AppIcon",    msg: "녹스1: 앱 아이콘 위에서 F2" },
    { name: "nox_1_TabBtn",     msg: "녹스1: 탭 버튼 위에서 F2" },
    { name: "nox_1_DeleteBtn",  msg: "녹스1: 모든 앱 제거 버튼 위에서 F2" },
    { name: "nox_1_LoadingBlocker", msg: "녹스1: 로딩 방해 제거 버튼 위에서 F2" },
    { name: "nox_1_XBtn",       msg: "녹스1: 게임 팝업 X 버튼 위에서 F2" },
    { name: "nox_1_EnterMap",   msg: "녹스1: 게임 입장 버튼 위에서 F2" },
    { name: "nox_1_MoveBtn",    msg: "녹스1: 이동 버튼 위에서 F2" },
    { name: "nox_1_TouchBtn",   msg: "녹스1: 팝업 터치 버튼 위에서 F2" },
    { name: "nox_1_SpinBtn",    msg: "녹스1: 룰렛 스핀 버튼 위에서 F2" },
    { name: "nox_1_PriceLeft",  msg: "녹스1: 왼쪽 상단 가격 위치에서 F2" },
    { name: "nox_1_PriceRight", msg: "녹스1: 오른쪽 하단 가격 위치에서 F2" },
    { name: "nox_1_outrullet", msg: "녹스1: 룰렛 버튼 나가기 위치에서 F2" },
    { name: "nox_1_BetLeft",    msg: "녹스1: 왼쪽 베팅 버튼 위에서 F2" },  ; 왼쪽 베팅 버튼 추가
    { name: "nox_1_BetRight",   msg: "녹스1: 오른쪽 베팅 버튼 위에서 F2" },

    ; 녹스 2번 버튼들
    { name: "nox_2_AppIcon",    msg: "녹스2: 앱 아이콘 위에서 F2" },
    { name: "nox_2_TabBtn",     msg: "녹스2: 탭 버튼 위에서 F2" },
    { name: "nox_2_DeleteBtn",  msg: "녹스2: 모든 앱 제거 버튼 위에서 F2" },
    { name: "nox_2_LoadingBlocker", msg: "녹스2: 로딩 방해 제거 버튼 위에서 F2" },
    { name: "nox_2_XBtn",       msg: "녹스2: 게임 팝업 X 버튼 위에서 F2" },
    { name: "nox_2_EnterMap",   msg: "녹스2: 게임 입장 버튼 위에서 F2" },
    { name: "nox_2_MoveBtn",    msg: "녹스2: 이동 버튼 위에서 F2" },
    { name: "nox_2_TouchBtn",   msg: "녹스2: 팝업 터치 버튼 위에서 F2" },
    { name: "nox_2_SpinBtn",    msg: "녹스2: 룰렛 스핀 버튼 위에서 F2" },
    { name: "nox_2_PriceLeft",  msg: "녹스2: 왼쪽 상단 가격 위치에서 F2" },
    { name: "nox_2_PriceRight", msg: "녹스2: 오른쪽 하단 가격 위치에서 F2" },
    { name: "nox_2_outrullet", msg: "녹스2: 룰렛 버튼 나가기 위치에서 F2" },
    { name: "nox_2_BetLeft",    msg: "녹스2: 왼쪽 베팅 버튼 위에서 F2" },  ; 왼쪽 베팅 버튼 추가
    { name: "nox_2_BetRight",   msg: "녹스2: 오른쪽 베팅 버튼 위에서 F2" }
]

StartButtonSave() {
    global currentIndex
    currentIndex := 1
    Hotkey("F2", SavePosition, "On")
    ShowNextMessage()
}

ShowNextMessage() {
    global currentIndex, buttonList
    if (currentIndex > buttonList.Length) {
        StopTooltip()
        MsgBox "모든 버튼 좌표 저장이 완료되었습니다."
        Hotkey("F2", SavePosition, "Off")
        return
    }
    StartTooltip(buttonList[currentIndex].msg)
}

SavePosition(*) {
    global currentIndex, buttonList, saveManager
    saveManager.SaveToIni(buttonList[currentIndex].name)
    currentIndex++
    ShowNextMessage()
}

StartTooltip(text) {
    global tooltipText
    tooltipText := text
    SetTimer(UpdateTooltip, 500) ; 0.5초마다 갱신
}

StopTooltip() {
    SetTimer(UpdateTooltip, 0) ; 타이머 해제
    ToolTip()
}

UpdateTooltip() {
    global tooltipText
    ToolTip(tooltipText, 10, 10)
}
