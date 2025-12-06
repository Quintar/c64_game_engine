#import "funcincludes_c64.asm"
/* Game specific names for the assets and main files */
.disk [filename="c64_game_engine.d64", name="C64GE", id="2025G"] {
    [name="C64GE"        , type="prg", segments="Autostart"],
    [name="MAIN"         , type="prg", segments="ProgStart"],
}
assemblyInfo(start, endoffile, 0)
.var nobasic = 1 //unload BASIC rom
/* Autostart after LOAD "*",8,1 the main program file */
autostart(start, progfilename, nobasic)
progfilename: .text @"MAIN\$00"

.segment ProgStart[outPrg="c64ge.prg"] "Programm Start"
    *=$0800
start:

Div8BitAcc(100, 15, $0400)

    lda #1
    sta $d020
loop:    jmp loop
endoffile: