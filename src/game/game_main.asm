#import "c64_game_logic.asm"
#import "hexe_main.asm"
#import "raster_interrupt.asm"

.segment ProgStart[outPrg="main.prg"] "Programm Start"
    *=ProgramStartAddress
    BeginSetupAndMainLoop()
    VariablesAndStrings()

.macro BeginSetupAndMainLoop() {
@begin: 
    InitialSetupStartsMainLoop()

    RasterInterrupt()

    FunctionImplementations()
}

.macro InitialSetupStartsMainLoop() {
// Initial Setup
    SetupFirstStart(screen1, false, false)

    //ShowMainMenu()
    ShowGamePlay() //Just for tests

    setupKeyboard(1, %00) // Setup keyboard with delay and repeat

    setStates(StateKeyboard, StateOverWorld) // Set initial game states

    InitRaster()
    OnRaster(onVBlankStart, doRaster) // Setup raster interrupt at start of VBlank to run our game loop, you can change the rasterline to your needs, just make sure to choose a line after the visible screen area and before the next frame starts (after line 312)

    MainLoop()
}

.macro MainLoop() {
    // Main Loop
loop:    
    switchLowLogic()
    jmp loop
}