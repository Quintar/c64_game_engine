//Program start at...
.var ProgramStartAddress = $0800

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

/// setups a startup sequence for the game, including setting the screen mode, clearing the screen, and showing a loading message
.macro SetupFirstStart(screen, widecolumns, manyrows) {
        DeactivateBasic()
        ClearScreen()
        CopyString(loadingtext, screen)

        Set40Column(widecolumns) // Set 40 column mode
        Set25Rows(manyrows) // Set 25 rows mode
}

.macro FunctionImplementations() {
 @doSoftScroll:
    //scrollScreenByPlayerDirection()
    rts

scrollScreen()

@doPollKeyboard:
    switchKeyLogic()
    rts

@doPollJoystick1:
    rts

@doPollJoystick2:
    rts

@doLogic:
    switchHighLogic()
    rts

@doRenderGraphics: // Shift screen based on playerDirection
    //shiftScreenByDirection()
    rts

@doLoadMapParts:
    loadMapPartsByDirection()
    rts

@QuickSetColorRam:
    QuickSetColorRamFromA()
    rts
    
@Copy: 
    CopyTo()
    rts

@readFile:
    ReadFile(zeroUnused1) //No rts needed as you jump away in this funciton; zeroUnused1 is the address of an error byte output

@PrintColumnToScreen: 
    PrintColumnToScreen(maplength)
    rts

@PrintRowToScreen: 
    PrintRowToScreen(maplength)
    rts

// Shift screen functions, take about half a frame each
    ShiftScreens()
}

.macro setStates(low, high) {
    lda #low
    sta lowState
    lda #high
    sta highState
}

.macro VariablesAndStrings() {
    //Variables
    @lowState: .byte 0
    @highState: .byte 0
    @playerDirection: .byte 0
    @currentMapX: .byte 0
    @currentMapY: .byte 0

    Strings()
}

.macro WASDKeyboardLogic(rtsAfter) {
    @switchKeyLogicMenu:
        getKeyboard(0)
        cmp #withKey('w')
        cmp #withKey('a')
        cmp #withKey('s')
        cmp #withKey('d')

        .if(rtsAfter){rts} else {jmp end}

    @switchKeyLogicWorld: 
        getKeyboard(0)
        cmp #withKey('w')
        bne !+
        lda #directionUp
        sta playerDirection
        jsr moveUp
        jmp endKeyWorld

!:      cmp #withKey('a')
        bne !+
        lda #directionLeft
        sta playerDirection
        jsr moveLeft
        jmp endKeyWorld

!:      cmp #withKey('s')
        bne !+
        lda #directionDown
        sta playerDirection
        jsr moveDown
        jmp endKeyWorld

!:      cmp #withKey('d')
        bne !+
        lda #directionRight
        sta playerDirection
        jsr moveRight

!:        //shiftScreenByDirection()
endKeyWorld:      
        .if(rtsAfter){rts} else {jmp end}

    @switchKeyLogicBattle:
        getKeyboard(0)
        cmp #withKey('w')
        cmp #withKey('a')
        cmp #withKey('s')
        cmp #withKey('d')

        .if(rtsAfter){rts} else {jmp end}

    @switchKeyLogicInventory:
        getKeyboard(0)
        cmp #withKey('w')
        cmp #withKey('a')
        cmp #withKey('s')
        cmp #withKey('d')

    end:
    .if(rtsAfter){rts}
}

.macro switchKeyLogic() {
    lda highState
    cmp #StateMenu
    bne !+ // Jump to next segment
    jsr switchKeyLogicMenu
    jmp endKey
!:  cmp #StateOverWorld
    bne !+
    jsr switchKeyLogicWorld
    jmp endKey
!:  cmp #StateInBattle
    bne !+
    jsr switchKeyLogicBattle
    jmp endKey
!:  cmp #StateInInventory
    bne !+
    jsr switchKeyLogicInventory

!:  
endKey:
    lda #0
    sta CurrentKey
    rts

    WASDKeyboardLogic(false)
}

.macro switchLowLogic() {
    lda lowState
    cmp #StateKeyboard
    bne !+
    jsr doPollKeyboard
    jmp end

!:  cmp #StateJoystick1
    bne !+
    jsr doPollJoystick1
    jmp end
    
!:  cmp #StateJoystick2
    bne !+
    jsr doPollJoystick2
    jmp end
    
!:  cmp #stateScroll
    bne !+
    jsr doSoftScroll
    jmp end
    
!:  cmp #statePaint
    bne !+
    jsr doRenderGraphics
    jmp end
    
!:  cmp #stateLoadMapParts
    bne !+
    jsr doLoadMapParts
    jmp end
    
!:  cmp #stateLogic
    bne !+
    jsr doLogic

    !:
    end:
}

.macro switchHighLogic() {
    lda highState
    cmp #StateMenu
    //beq showMenuLogic

    cmp #StateOverWorld
    //beq overWorldLogic

    cmp #StateInBattle
    //beq inBattleLogic

    cmp #StateInInventory
    //beq inInventoryLogic
}

.macro shiftScreenByDirection() {
    lda playerDirection
    cmp #directionUp
    bne !+
    jsr moveUp
!:  cmp #directionDown
    bne !+
    jsr moveDown
!:  cmp #directionLeft
    bne !+
    jsr moveLeft
!:  cmp #directionRight
    bne !+
    jsr moveRight
!:  
}

.macro loadMapPartsByDirection() {
    lda playerDirection
    cmp #directionUp
    bne !+
    jsr PrintRowToScreen
!:  cmp #directionDown
    bne !+
    jsr PrintRowToScreen

!:  cmp #directionLeft
    bne !+
    jsr PrintColumnToScreen
!:  cmp #directionRight
    bne !+
    jsr PrintColumnToScreen
!:  
}

.macro scrollScreenByPlayerDirection() {
    lda playerDirection
    cmp #directionUp
    bne !+
    jsr scrollScreenUp
!:  cmp #directionDown
    bne !+
    jsr scrollScreenDown
!:  cmp #directionLeft
    bne !+
    jsr scrollScreenLeft
!:  cmp #directionRight
    bne !+
    jsr scrollScreenRight
!:
}

.macro scrollScreen() {
@scrollScreenUp: scrollScreenUp(3)
    rts
@scrollScreenDown: scrollScreenDown(3)
    rts
@scrollScreenLeft: scrollScreenLeft(3)
    rts
@scrollScreenRight: scrollScreenRight(3)
    rts    
}

.macro LoadAndShowBitmap(image, colors, characters, output) {
    ClearScreen()
    SetupScreenMultiBitmap(0)
    SetCharacterMapPointer(4)
    SetScreenColors(0, 5)
    setColors(9,14,8)
    // Show Title Picture
    SetPointers(image, $2000, loadcol)
        jmp readFile
    loadcol: SetPointers(colors, colorram, loadchar)
        jmp readFile
    loadchar: SetPointers(characters, output, endtitleload)
        jmp readFile
    endtitleload:
}