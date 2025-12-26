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

    //My variables
    .var text     = $17      // Textaddressen Pointer
    .var file     = $19      // Dateiinhaltaddressen Pointer
    .var jmpto    = $22      // Springe nach Addressen Pointer

    .var scrnpos  = $22      // Cursor Position Addressen Pointer
    .var sprpak   = $71      // Spritepacket
    .var sprpos   = $72      // Spritearrayposition
    .var tileHeight = $28
    .var tileWidth = $29
    .var currentPaintTile = $26   // Aktuelles Tile paint cursor Pointer
    .var currentTileScreen = $2b // Aktueller Tile paint Screen cursor Pointer
    .var currentTile = $2d   // Aktueller tile pointer zum bearbeiten
    .var currentScreen = $2f // Aktueller screen position pointer zum bearbeiten
    .var spritet = $07f8
    // Directions
    .var directionNull = 0
    .var directionLeft = 1
    .var directionRight = 2
    .var directionUp = 3
    .var directionDown = 4

    // Program/Game States
    .var stateNull = 0
    .var stateMenu = 1
    .var stateOverWorldKeyboard = 2
    .var stateOverWorldScroll = 3
    .var stateOverWorldPaint = 4


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

