
.macro SetupFirstStart() {
        DeactivateBasic()
        ClearScreen()
        CopyString(loadingtext, screen1)

        Set40Column(true) // Set 40 column mode
        Set25Rows(true) // Set 25 rows mode
}

.macro ShowMainMenu() {
    ClearScreen()
    SetupScreenMultiBitmap(0)
    SetCharacterMapPointer(4)
    SetScreenColors(0, 5)
    setColors(9,14,8)
    // Show Title Picture
    SetPointers(hexetitlepic, $2000, loadcol)
        jmp readFile
    loadcol: SetPointers(hexetitlecol, colorram, loadchar)
        jmp readFile
    loadchar: SetPointers(hexetitlechar, screen1, endtitleload)
        jmp readFile
    endtitleload:
}

.macro ShowGamePlay() {
    .var MapRam = $4000
    .var maplength = 64
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