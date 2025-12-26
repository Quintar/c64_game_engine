#import "funcincludes_c64.asm"
/* Game specific names for the assets and main files */
.disk [filename="c64_game_engine.d64", name="C64GE", id="2025G"] {
    [name="C64GE"        , type="prg", segments="Autostart"],
    [name="MAIN"         , type="prg", segments="ProgStart"],
    //Your own asset files here
    [name="SPRITES.DAT"  , type="prg", prgFiles="game/assets/sprite.dat"],
    [name="HEXEBACKMAP"  , type="prg", prgFiles="game/assets/smallmap_64x64.bin"],
    [name="HEXEBACKCHARS", type="prg", prgFiles="game/assets/smallmap_chars.bin"],
    
    [name="HEXETITLEPIC" , type="prg", prgFiles="game/assets/hexetitlepic"],
    [name="HEXETITLECHAR", type="prg", prgFiles="game/assets/hexetitlechar"],
    [name="HEXETITLECOL" , type="prg", prgFiles="game/assets/hexetitlecol"],
}
.var nobasic = 1 //unload BASIC rom
/* Autostart after LOAD "*",8,1 the main program file */
autostart(begin, progfilename, nobasic)
progfilename: .text @"MAIN\$00"

#import "game/game_main.asm"
endoffile:

assemblyInfo(begin, endoffile, 0)
