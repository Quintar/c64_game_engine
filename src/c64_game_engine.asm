.segment ProgStart[outPrg="c64ge.prg"] "Programm Start"
    *=$0803
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

    .var onCharScreen = 50
    .var onCharScreenEnd = onCharScreen + 200
    .var onVBlankStart = 300
    .var onVBlankEnd = 312


// Set up screen
    lda #black
    sta bordercolor          // border color
    sta screencolor          // background color
    Set40Column(false)
    Set25Rows(false)

// Setup first raster interrupt
    InitRaster()
    //OnRaster(onCharScreen, doRaster) // setup raster interrupt at line 50

loop:    
    
    jmp loop

doRaster:
    EndRaster()


doSoftScroll:
    rts

doPollInput:
    rts

doGameLogic:
    rts

doRenderGraphics:
    rts

doLoadMapParts:
    rts

