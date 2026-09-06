.var maplength = 120

.macro ShowMainMenu() {
    LoadAndShowBitmap(hexetitlepic, hexetitlecol, hexetitlechar, screen1)
}

.macro ShowGamePlay() {
    .var MapRam = $4000
        // Load Sprites and Background-Data
    hexmap: SetPointers(hexebackmap, MapRam, bchar)
            jmp readFile
    bchar: SetPointers(hexebackchars, charram4, endreads)
            jmp readFile
    endreads:

    // Set background color to black
        SetBackgroundColor(2)
    // Set Colorram to white
        lda #1
        jsr QuickSetColorRam

    //Set characters to mem-map 4
        SetCharacterMapPointer(4)
        setColors(0,0,0)

    //Copy first map-screen to screen
        SetupCopy(MapRam, screen1, 1255, maplength-39)
        jsr Copy
}

.macro Strings() {
    @hexetitlepic:   .text @"HEXETITLEPIC\$00"
    @hexetitlecol:   .text @"HEXETITLECOL\$00"
    @hexetitlechar:  .text @"HEXETITLECHAR\$00"

    @spritefilename: .text @"SPRITES.DAT\$00"
    @hexebackmap:    .text @"HEXEBACKMAP\$00"
    @hexebackchars:  .text @"HEXEBACKCHARS\$00"
    @hexebacktiles:  .text @"HEXEBACKTILES\$00"
    @hexebackattribs:.text @"HEXEBACKATTRIBS\$00"

    @loadingtext:    .text @"loading...\$00"
}