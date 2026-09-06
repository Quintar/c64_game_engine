// Raster timings
.var onCharScreen = 50
.var onCharScreenEnd = onCharScreen + 200
.var onVBlankStart = 300
.var onVBlankEnd = 312

#import "c64_game_logic.asm"
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
    SetupFirstStart(screen1, false, false)

    //ShowMainMenu()
    ShowGamePlay() //Just for tests

    setupKeyboard(1, %00) // Setup keyboard with delay and repeat

    setStates(StateKeyboard, StateOverWorld) // Set initial game states

    InitRaster()
    OnRaster(onVBlankStart, doRaster) // Setup raster interrupt at start of VBlank to run our game loop, you can change the rasterline to your needs, just make sure to choose a line after the visible screen area and before the next frame starts (after line 312)

// Main Loop
loop:    
    switchLowLogic()
jmp loop

doRaster:
    inc lowState
    lda lowState
    cmp #stateLogic+1
    bne !+
    lda #StateKeyboard
    sta lowState
    !:
    sta screen1 // Just for testing, output the lowState to the screen
    EndRaster()

doSoftScroll:
    //scrollScreenByPlayerDirection()
    rts

scrollScreen()

doPollKeyboard:
    switchKeyLogic()
    rts

doPollJoystick1:
    rts

doPollJoystick2:
    rts

doLogic:
    switchHighLogic()
    rts

doRenderGraphics: // Shift screen based on playerDirection
    //shiftScreenByDirection()
    rts

doLoadMapParts:
    loadMapPartsByDirection()
    rts

QuickSetColorRam:
    QuickSetColorRamFromA()
    rts
    
Copy: 
    CopyTo()
    rts

readFile:
    ReadFile(zeroUnused1) //No rts needed as you jump away in this funciton; zeroUnused1 is the address of an error byte output

PrintColumnToScreen: 
    PrintColumnToScreen(maplength)
    rts

PrintRowToScreen: 
    PrintRowToScreen(maplength)
    rts

//Functions
// Shift screen functions, take about half a frame each
ShiftScreens()

//Variables
lowState: .byte 0
highState: .byte 0
playerDirection: .byte 0
currentMapX: .byte 0
currentMapY: .byte 0

Strings()
