.macro SetupFirstStart() {
    // Memorylocations for specific variables
        .var CurrentScreen = screen1       //Beginning of first row screenX
        //.var LowerScreenRam = CurrentScreen+$3c1  //Beginning of last row screenX+$3c1
        .var AttribMapRam = $2350
        .var MapRam = $4000
        //.var TileMapRam = $4000
        //.var MapLowerMem = $5000
        //.var MapHigherMem = $6000
        //.var mapline = 0
        .var maplength = 80

        // Raster timings
        .var onCharScreen = 50
        .var onCharScreenEnd = onCharScreen + 200
        .var onVBlankStart = 300
        .var onVBlankEnd = 312


        DeactivateBasic()
        ClearScreen()
        CopyString(loadingtext, CurrentScreen)

    // Load Sprites and Background-Data
    hexmap: SetPointers(hexebackmap, MapRam, bchar)
            jmp readFile
    bchar: SetPointers(hexebackchars, charram4, endreads)
            jmp readFile
    endreads:

        Set40Column(true) // Set 40 column mode
        Set25Rows(true) // Set 25 rows mode

    // Set background color to black
        SetBackgroundColor(2)
    // Set Colorram to white
        lda #1
        jsr QuickSetColorRam

    //Set characters to mem-map 4
        SetCharacterMapPointer(4)
        setColors(0,0,0)

    //Copy first map-screen to screen
        SetupQuickCopy(MapRam, screen1, 1255, 63-39)
        jsr QuickCopy
        //QuickCopyToScreen(MapRam, screen1, maplength)


    // For Sprites
        //activateSprites(%00000011)

    // Set Map pointer
        Set16Bit(MapRam, mapPointer) // Set MapPointer to MapRam
//        Set16Bit(screen1+20, screen_pointer_dest) //Set screen_pointer_dest to screen3+40 (right column)
//        Set16Bit(MapRam+1000, map_column) //Set next column from map

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