#import "funcincludes_c64.asm"
/* Game specific names for the assets and main files.
   You can change the filename, name and id of the disk.
*/
.disk [filename="c64_game_engine.d64", name="C64GE", id="2025G", showInfo] {
    [name="AUTOSTART"    , type="prg", segments="Autostart"],
    [name="MAIN"         , type="prg", segments="ProgStart"],
    //Your own asset files here
    [name="SPRITES"      , type="prg", prgFiles="assets/sprite.dat"],
    [name="HEXEBACKMAP"  , type="prg", prgFiles="assets/smallmap_64x64.bin"],
    [name="HEXEBACKCHARS", type="prg", prgFiles="assets/smallmap_chars.bin"],
    
    [name="HEXETITLEPIC" , type="prg", prgFiles="assets/hexetitlepic"],
    [name="HEXETITLECHAR", type="prg", prgFiles="assets/hexetitlechar"],
    [name="HEXETITLECOL" , type="prg", prgFiles="assets/hexetitlecol"],
}
.var nobasic = 1 //unload BASIC rom
/* Autostart after LOAD "*",8,1 the main program file */
autostart(begin, progfilename, nobasic)
progfilename: .text @"MAIN\$00"

#import "game/game_main.asm"
endoffile:

assemblyInfo(begin, endoffile, 0)
