// Raster timings
.var onCharScreen = 50
.var onCharScreenEnd = onCharScreen + 200
.var onVBlankStart = 300
.var onVBlankEnd = 312

#import "hexe_main.asm"

.segment ProgStart[outPrg="main.prg"] "Programm Start"
    *=$0800
begin: 
// Game Coding Style: Statemachine
// Each state is represented by a subroutine:
// - Poll keyboard and/or Joystick input
// - Game logic
// - Render graphics to screen
//  -  soft scroll (reset at edge of screen)
//  -  update sprites-positions
//  -  load new map parts (every 3 steps) if needed
// - raster wait to end of frame

// High level states could be:
// - Title screen
// - Gameplay
//  - Game-screen
//  - Status-part
//  - Inventory screen
//  - Pause
// - Game over

    // Low level states
    .var StateKeyboard = 1
    .var StateJoystick1 = 2
    .var StateJoystick2 = 3
    .var stateScroll = 4
    .var stateLoadMapParts = 5
    .var statePaint = 6
    .var stateLogic = 7

    // Program/Game States
    .var StateNull = 0
    .var StateMenu = 1
    .var StateOverWorld = 2
    .var StateInBattle = 3
    .var StateInInventory = 4

    // Directions
    .var directionNull = 0
    .var directionLeft = 1
    .var directionRight = 2
    .var directionUp = 3
    .var directionDown = 4

// Initial Setup
    SetupFirstStart()

    //ShowMainMenu()
    ShowGamePlay() //Just for tests

    setupKeyboard(1, %00) // Setup keyboard with delay and repeat

    setStates(StateKeyboard, StateOverWorld) // Set initial game states

// Main Loop
loop:    
    lda lowState
    beq loop
    switchLowLogic()
    lda #StateKeyboard
    //lda #StateNull
    sta lowState
jmp loop

doRaster:
    EndRaster()

doSoftScroll:
    rts

doPollKeyboard:
    switchKeyLogic()
    //rts

doPollJoystick1:
    rts

doPollJoystick2:
    rts

doLogic:
    lda highState
    switchHighLogic()
    rts

doRenderGraphics:
    rts

doLoadMapParts:
    rts

QuickSetColorRam:
    QuickSetColorRamFromA()
    rts
    
Copy: CopyTo()
    rts

readFile:
    ReadFile(zeroUnused1) //No rts needed as you jump away in this funciton; zeroUnused1 is the address of an error byte

.macro setStates(low, high) {
    lda #low
    sta lowState
    lda #high
    sta highState
}

.macro switchLowLogic() {
    cmp #StateKeyboard
    bne !+
    jsr doPollKeyboard

!:  cmp #StateJoystick1
    bne !+
    jsr doPollJoystick1
    
!:  cmp #StateJoystick2
    bne !+
    jsr doPollJoystick2
    
!:  cmp #stateScroll
    bne !+
    jsr doSoftScroll
    
!:  cmp #statePaint
    bne !+
    jsr doRenderGraphics
    
!:  cmp #stateLoadMapParts
    bne !+
    jsr doLoadMapParts
    
!:  cmp #stateLogic
    bne !+
    jsr doLogic

    !:
}

.macro switchKeyLogic() {
    lda highState
    cmp #StateMenu
    bne !+ // Jump to next segment
    jsr switchKeyLogicMenu

!:  cmp #StateOverWorld
    bne !+
    jsr switchKeyLogicWorld

!:  cmp #StateInBattle
    bne !+
    jsr switchKeyLogicBattle

!:  cmp #StateInInventory
    bne !+
    jsr switchKeyLogicInventory

    !: rts

    KeyboardLogic()
}

.macro switchHighLogic() {
    cmp #StateMenu
    //beq showMenuLogic

    cmp #StateOverWorld
    //beq overWorldLogic

    cmp #StateInBattle
    //beq inBattleLogic

    cmp #StateInInventory
    //beq inInventoryLogic
}

.macro KeyboardLogic() {
    @switchKeyLogicMenu:
        getKeyboard(0)
        cmp #withKey('w')
        cmp #withKey('a')
        cmp #withKey('s')
        cmp #withKey('d')

        rts

    @switchKeyLogicWorld: 
        getKeyboard(0)
        cmp #$09 //withKey('w')
        bne !+
        jmp doMoveUp
!:      cmp #$0a//#withKey('a')
        bne !+
        jmp doMoveLeft
!:      cmp #$0d //#withKey('s')
        bne !+
        jmp doMoveDown
!:      cmp #$12//#withKey('d')
        bne !+
        jmp doMoveRight
!:      rts

    @switchKeyLogicBattle:
        getKeyboard(0)
        cmp #withKey('w')
        cmp #withKey('a')
        cmp #withKey('s')
        cmp #withKey('d')

        rts

    @switchKeyLogicInventory:
        getKeyboard(0)
        cmp #withKey('w')
        cmp #withKey('a')
        cmp #withKey('s')
        cmp #withKey('d')

        rts
}

//Functions
doMoveUp:
    ShiftScreenUp()
    lda #0
    sta $cb
    rts

doMoveDown:
    ShiftScreenDown()
    lda #0
    sta $cb
    rts

doMoveLeft:
    ShiftScreenLeft()
    lda #0
    sta $cb
    rts

doMoveRight:
    ShiftScreenRight()
    lda #0
    sta $cb
    rts


//Variables
lowState: .byte 0
highState: .byte 0

Strings()
