#import "funcincludes_c64.asm"
/* Game specific names for the assets and main files */
.disk [filename="c64_game_engine.d64", name="C64GE", id="2025G"] {
    [name="C64GE"        , type="prg", segments="Autostart"],
    [name="MAIN"         , type="prg", segments="ProgStart"],
}
.var nobasic = 1 //unload BASIC rom
/* Autostart after LOAD "*",8,1 the main program file */
autostart(begin, progfilename, nobasic)
progfilename: .text @"MAIN\$00"

#import "c64_game_engine.asm"
endoffile:

assemblyInfo(begin, endoffile, 0)
