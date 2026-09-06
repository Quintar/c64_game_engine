#import "includes/funcincludes_c64.asm"
/* Game specific names for the assets and main files.
   You can change the filename, name and id of the disk.
*/
.disk [filename="c64_game_engine.d64", name="C64GE", id="2025G", showInfo] {
    [name="AUTOSTART"    , type="prg", segments="Autostart"],
    [name="MAIN"         , type="prg", segments="ProgStart"],
    //Your own asset files here
    [name="SPRITES"      , type="prg", prgFiles="game/assets/sprite.dat"],
    [name="HEXEBACKMAP"  , type="prg", prgFiles="game/assets/Hexe_1bit_change - (8bpc 120x75) Map.bin"],
    [name="HEXEBACKCHARS", type="prg", prgFiles="game/assets/Hexe_1bit_change-Chars.bin"],
    
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
