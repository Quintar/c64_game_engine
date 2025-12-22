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

loop:    jmp loop

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

