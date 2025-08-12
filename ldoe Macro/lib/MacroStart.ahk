; 매크로 시작
GAME_LOAD_TIME := 55000  ; 60초 (게임이 켜지는 데 걸리는 시간)
GAME_LOAD_TIME_NEXT := 40000 ; 50초 (게임 로딩 방해 이후 걸리는 시간)
SCENE_LOAD_TIME := 18000 ; 15초 (게임 안으로 들어가는 시간)
SLEEP_BETWEEN_CLICKS := 2000
SPIN_DELAY := 4500 ;스핀 딜레이 3초

#Include GetNum.ahk
#Include CheckImage.ahk

global spin_count := 0  ;스핀 횟수 추적기
global prev_Price := 0  ;스핀 전
global curr_Price := 0  ;스핀 돌아가는 중
global next_Price := 0  ;스핀 완전히 돌아간 후


StartMacro() {

    ToolTip "매크로가 실행되었습니다!", 10, 10
    SetTimer(() => ToolTip(), -1500)

    Hotkey("F12", (*) => ExitApp()) ; 종료키

    loop {
        main_loop()
    }

}

global saveManager 

main_loop() {
    global spin_count  ; spin_count를 글로벌로 선언하여 접근 가능하게 합니다.

    ; spin_count 초기화
    spin_count := 0  ; 루프마다 spin_count를 0으로 초기화

    open_game("nox_1")

    Sleep(SLEEP_BETWEEN_CLICKS)

    saveManager.LoadFromIni("nox_1_EnterMap")

    Sleep(SCENE_LOAD_TIME)

    go_roulette("nox_1")

    loop(5) {  ;최소 베팅금액 설정
        saveManager.LoadFromIni("nox_1_BetLeft")
        Sleep(500)
    }

    saveManager.LoadFromIni("nox_1_TabBtn")

    Sleep(300)

    ;2번째 기기 실행
    open_game("nox_2")

    saveManager.LoadFromIni("nox_1_SpinBtn")  ;스핀으로 다시 게임 접속(연결끊김 상태)

    ;스핀 돌림
    Sleep(2000)

    spin_and_count_preview()

    saveManager.LoadFromIni("nox_2_EnterMap")

    Sleep(SCENE_LOAD_TIME)

    go_roulette("nox_2")

    loop(5) {  ;최소 베팅금액 설정
        saveManager.LoadFromIni("nox_2_BetLeft")
        Sleep(500)
    }

    spin_and_count()  ;spincount-1 만큼 시행

    Sleep(1000)

    saveManager.LoadFromIni("nox_2_outrullet")

    saveManager.LoadFromIni("nox_2_MoveBtn")

    move_relative(0, 50, 8000)

    Sleep(SCENE_LOAD_TIME) ; 맵에 당첨되기 전까지 저장을 시킴

    close_game_all() ;모든 게임 종료
    
    Sleep(5000)

    ;룰렛 고배율 보상 획득
    open_game("nox_1") 

    Sleep(SLEEP_BETWEEN_CLICKS)

    saveManager.LoadFromIni("nox_1_EnterMap")

    Sleep(SCENE_LOAD_TIME)

    go_roulette("nox_1")

    ;고배율 설정
    loop(5) {  ;최소 베팅금액 설정
        saveManager.LoadFromIni("nox_1_BetRight")
        Sleep(500)
    }

    ;스핀이 잘 작동했는지 확인
    highrate_spin()

    Sleep(1000)
    ;나가서 안전하게 저장하기
    saveManager.LoadFromIni("nox_1_outrullet")

    Sleep(3000)

    saveManager.LoadFromIni("nox_1_MoveBtn")

    move_relative(0, 50, 8000)

    saveManager.LoadFromIni("nox_1_TabBtn")
    Sleep(1000)

    saveManager.LoadFromIni("nox_1_DeleteBtn")
    Sleep(5000)
}

move_relative(dx, dy, hold_ms := 6000) {
    ; 1. 현재 마우스 위치 가져오기
    MouseGetPos(&start_x, &start_y)
    
    ; 2. 목표 위치 계산 (현재 위치 + 상대적 이동 거리)
    target_x := start_x + dx
    target_y := start_y + dy
    
    ; 3. 마우스 왼쪽 버튼 누르기 (드래그 시작)
    MouseClick("Left", start_x, start_y, 1, 0, "D")
    
    ; 4. 부드러운 이동 (50단계로 나누어 이동)
    steps := 50
    Loop steps {
        ; 현재 진행률에 따른 위치 계산
        progress := A_Index / steps
        current_x := start_x + (dx * progress)
        current_y := start_y + (dy * progress)
        
        ; 마우스 이동
        MouseMove(current_x, current_y, 0)
        Sleep(10)  ; 각 단계마다 10ms 대기 (부드럽게 이동)
    }
    
    ; 5. 정확히 목표 위치로 이동 (반올림 오차 보정)
    MouseMove(target_x, target_y, 0)
    
    ; 6. 10초 대기
    Sleep(hold_ms)
    
    ; 7. 마우스 버튼 떼기 (드래그 종료)
    MouseClick("Left", target_x, target_y, 1, 0, "U")
}

highrate_spin() {
    global prev_Price, curr_Price, next_Price

    prev_Price := get_price("nox_1") 

    saveManager.LoadFromIni("nox_1_SpinBtn")

    Sleep(5000)

    next_Price := get_price("nox_1") 

    if IsJackPot() {
        HandleJack("nox_1")
        return
    }

    if (next_Price <= prev_Price) {
        rebetHandle()  ; 가격이 이전 가격보다 작거나 같으면 재배팅 처리
    }

}

rebetHandle() {
    ;창 닫고
    saveManager.LoadFromIni("nox_1_TabBtn")
    Sleep(1000)

    saveManager.LoadFromIni("nox_1_DeleteBtn")
    Sleep(1000)

    open_game("nox_2")  ; 녹스 2 켜서 초기화

    saveManager.LoadFromIni("nox_2_TabBtn")
    Sleep(1000)

    saveManager.LoadFromIni("nox_2_DeleteBtn")
    Sleep(1000) 
    ;다시 닫고
    open_game("nox_1") 

    Sleep(SLEEP_BETWEEN_CLICKS)

    saveManager.LoadFromIni("nox_1_EnterMap")

    Sleep(SCENE_LOAD_TIME)

    go_roulette("nox_1")

    ;고배율 설정
    loop(5) {  ;최대 베팅금액 설정
        saveManager.LoadFromIni("nox_1_BetRight")
        Sleep(500)
    }

    saveManager.LoadFromIni("nox_1_SpinBtn")

    Sleep(5000)
}

go_roulette(prefix) {
    saveManager.LoadFromIni(prefix "_MoveBtn")
    move_relative(0, -50)  ; 룰렛 위치로 이동

    saveManager.LoadFromIni(prefix "_TouchBtn")
    Sleep(3000)
}

spin_and_count_preview() {
    global spin_count, prev_Price, curr_Price, next_Price

    prev_Price := get_price("nox_1") ;이전 가격

    ; 스핀 버튼 클릭
    saveManager.LoadFromIni("nox_1_SpinBtn")  ; 스핀 버튼 좌표 누르기
    Sleep(1000)
    curr_Price := get_price("nox_1")

    Sleep(SPIN_DELAY)
    next_Price := get_price("nox_1")  ;스핀 이후 가격

    if IsJackPot() {
        HandleJack("nox_1")
        spin_count++
        spin_and_count_preview()
        return
    }

    if (prev_Price != curr_Price) {
        spin_count++
    }
    
    ;MsgBox("이전 가격: " prev_Price "`n현재 가격: " curr_Price "`n다음 가격: " next_Price "`n스핀: " spin_count)

    if (next_Price > prev_Price) {
        return
    }

    Sleep(200)


    spin_and_count_preview()
}

spin_and_count() {
    global spin_count, prev_Price, curr_Price, next_Price

    Loop(spin_count - 1) {
        prev_Price := get_price("nox_2") ; 두 번째 게임의 이전 가격

        ; 두 번째 게임 스핀 버튼 클릭
        saveManager.LoadFromIni("nox_2_SpinBtn")  ; 스핀 버튼 좌표 누르기
        Sleep(1000)
        curr_Price := get_price("nox_2")  ; 두 번째 게임의 현재 가격

        Sleep(SPIN_DELAY)
        next_Price := get_price("nox_2")  ; 두 번째 게임의 스핀 이후 가격

        if IsJackPot() {
            ;잭팟 핸들러
            HandleJack("nox_2")
            continue
        }

        ; while문을 사용하여, 가격 변동이 없으면 한 번 더 돌림
        while (prev_Price = curr_Price) {
            ToolTip "가격 변동 없음. 다시 스핀합니다."
            prev_Price := get_price("nox_2")
            saveManager.LoadFromIni("nox_2_SpinBtn")  ; 스핀 버튼 좌표 재클릭
            Sleep(1000)
            curr_Price := get_price("nox_2")
            Sleep(SPIN_DELAY)
            next_Price := get_price("nox_2")
        }

    }
}

HandleJack(prefix, step := 50, dwell_ms := 80) {
    global saveManager
    try {
        posTab := saveManager.GetXY(prefix "_XBtn") ; [x,y]
        posTop := saveManager.GetXY(prefix "_SpinBtn")    ; [x,y]

        ; 좌표 값 디버깅
        ToolTip "posTab: " posTab[1] ", " posTab[2] "`nposTop: " posTop[1] ", " posTop[2]
        Sleep 1000  ; 1초 동안 좌표 출력 확인

        if !(IsSet(posTab) && IsSet(posTop) && posTab.Length = 2 && posTop.Length = 2)
            throw Error("저장된 좌표가 없습니다: " prefix "_TabBtn / " prefix "_Top")

        ; 직사각형 기본 좌표 계산
        x1 := Min(posTab[1], posTop[1])
        x2 := Max(posTab[1], posTop[1])
        y1 := Min(posTab[2], posTop[2])
        y2 := Max(posTab[2], posTop[2])

        ; 첫 번째 좌표가 잘못 갔을 경우 강제로 보정 (좌표를 화면의 중간값으로 보정)
        if (x1 = 1920 && y1 = 1080) {
            x1 := 100  ; 예시로 100, 100으로 좌표 보정 (적절한 값으로 설정)
            y1 := 100
        }

        ; 전체 거리 계산
        xDist := x2 - x1
        yDist := y2 - y1

        ; 10% 오프셋 적용
        x1 := x1 + Floor(xDist * 0.1)
        x2 := x2 - Floor(xDist * 0.1)
        y1 := y1 + Floor(yDist * 0.1)
        y2 := y2 - Floor(yDist * 0.1)

        if (x2 - x1 < 2 || y2 - y1 < 2)
            throw Error("클릭 범위가 너무 작습니다.")

        ; y 큰값 → 작은값, x 좌→우
        y := y2

        while (y >= y1) {
            x := x1
            while (x <= x2) {
                ; 클릭 좌표와 이동 전에 좌표 보정 확인
                ToolTip "클릭 좌표: " x ", " y  ; 클릭 좌표를 출력
                MouseMove(x, y, 0)  ; 절대 좌표로 마우스 이동 (v2 문법)
                Click()  ; 클릭 실행
                if (dwell_ms > 0)
                    Sleep dwell_ms
                x += step
            }
            y -= step
        }

        Sleep(6000) ;3초 기다리고
        saveManager.LoadFromIni(prefix "_BetLeft")
        return true
    } catch as e {
        MsgBox "HandleJack 실패: " e.Message
        return false
    }
}

get_price(prefix) {
    ; 좌표 받아오기 (nox_1 또는 nox_2를 사용하여 좌표 가져오기)
    posL := saveManager.GetXY(prefix "_PriceLeft")  ; 왼쪽 가격 위치 좌표
    posR := saveManager.GetXY(prefix "_PriceRight")  ; 오른쪽 가격 위치 좌표

    ; 직사각형 정규화
    x1 := Min(posL[1], posR[1])  ; 직사각형의 왼쪽 상단 x 좌표
    y1 := Min(posL[2], posR[2])  ; 직사각형의 왼쪽 상단 y 좌표
    x2 := Max(posL[1], posR[1])  ; 직사각형의 오른쪽 하단 x 좌표
    y2 := Max(posL[2], posR[2])  ; 직사각형의 오른쪽 하단 y 좌표

    ; OCR을 사용하여 해당 영역에서 가격을 인식
    recognized_number := CaptureAndRecognizeNumber([x1, y1, x2, y2])

    digits := RegExReplace(Trim("" recognized_number), "[^\d]")
    ; 인식된 가격 반환
    return (digits = "") ? 0 : Integer(digits)
}

; 게임 들어가는 매크로
open_game(prefix) {
    saveManager.LoadFromIni(prefix "_AppIcon")

    Sleep(GAME_LOAD_TIME)

    saveManager.LoadFromIni(prefix "_LoadingBlocker")

    Sleep(GAME_LOAD_TIME_NEXT)

    Loop(8) {
        saveManager.LoadFromIni(prefix "_XBtn")  ; XBtn 버튼 좌표 불러오기
        Sleep(500)  ; 클릭 후 0.5초 대기 (반복 시 너무 빨리 클릭하지 않도록)
    }
}

;게임창을 모두 닫음
close_game_all() {
    saveManager.LoadFromIni("nox_1_TabBtn")
    Sleep(1000)

    saveManager.LoadFromIni("nox_1_DeleteBtn")
    Sleep(1000)

    saveManager.LoadFromIni("nox_2_TabBtn")
    Sleep(1000)

    saveManager.LoadFromIni("nox_2_DeleteBtn")
    Sleep(1000)
}


;F3::spin_and_count_preview()