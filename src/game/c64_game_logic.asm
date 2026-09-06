
/// setups a startup sequence for the game, including setting the screen mode, clearing the screen, and showing a loading message
.macro SetupFirstStart(screen, widecolumns, manyrows) {
        DeactivateBasic()
        ClearScreen()
        CopyString(loadingtext, screen)

        Set40Column(widecolumns) // Set 40 column mode
        Set25Rows(manyrows) // Set 25 rows mode
}

.macro setStates(low, high) {
    lda #low
    sta lowState
    lda #high
    sta highState
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
!:      cmp #withKey('a')
        bne !+
        lda #directionLeft
        sta playerDirection
        jsr moveLeft
!:      cmp #withKey('s')
        bne !+
        lda #directionDown
        sta playerDirection
        jsr moveDown
!:      cmp #withKey('d')
        bne !+
        lda #directionRight
        sta playerDirection
        jsr moveRight

        //shiftScreenByDirection()
!:      .if(rtsAfter){rts} else {jmp end}

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

!:  cmp #StateOverWorld
    bne !+
    jsr switchKeyLogicWorld

!:  cmp #StateInBattle
    bne !+
    jsr switchKeyLogicBattle

!:  cmp #StateInInventory
    bne !+
    jsr switchKeyLogicInventory

!:  
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