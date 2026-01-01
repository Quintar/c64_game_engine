.macro ClearScreen() {
        jsr $e544 //Clear Screen
}

.macro Set40Column(yes) {
        lda viccfg1
        and #$f7 // clear bit 3 = 40 columns
        .if (yes) {
            ora #$04 // set bit 3 = 39 columns
        }
        sta viccfg1
}

.macro Set25Rows(yes) {
        lda viccfg0
        and #$f7 // clear bit 3 = 25 rows
        .if (yes) {
            ora #$04 // set bit 3 = 24 rows
        }
        sta viccfg0
}

.macro SetScreenColors(fore, back) {
        lda #fore
        sta foreground
        lda #back
        sta background
}

.macro SetScreen(screen) {
        lda $d018
        and #%00001111 // Reset Screen Bits
        ora #screen<<4 // Set Screen Bits
        sta $d018
}

// Sets both background colors to 'backcolor'
.macro SetBackgroundColor(backcolor) {
    lda #backcolor
    sta $d020
    sta $d021
}

// Sets System to Multicolor Bitmap mode with background color 'backcolor'
.macro SetupScreenMultiBitmap(backcolor) {
    SetBackgroundColor(backcolor)
    lda #$3b
    sta $d011 //Bitmap mode
    lda #$18
    sta $d016 //Multicolor mode
    sta $d018 //Screen @ $0400 Pic @ $2000*/
}

/* 
Deactivates interrupts, 
Activates Multicolor, sets 38 coloumn mode, scroll set to 0, 
Doesn't touch beam bit, deactivates extended color mode, deactivates bitmap mode, sets 24 lines mode, scroll set to 0
*/
.macro SetScreenMultiColorMode() {
    sei
    lda viccfg0 //#%00010000
    and #%10010000 // Bit 7=8tes Bit Rasterposition// 6=Extended-Color-mode// 5=1Grafikmode/0Textmode// 4=Screen on/off// 3=25Rows// 2-0=scroll Y
    //ora #%00000000
    sta viccfg0 

    lda #%00010000 // Bit 7-5=unused// 4=Multi-Color-mode// 3=40 coloumns// 2-0=scroll X
    sta viccfg1
}

.macro SetCharacterMapPointer(to) {
        lda asciicfg
        and #%11110001  // Reset character pointer
        ora #to*2  // Set character pointer to 4
        sta asciicfg
}

// Copies screen data [from] memory [to] screen memory.
// The [offset] the width in bytes of the map to copy
// .size = 157 Byte
.macro QuickCopyToScreen(from, to, offset) {
    ldy #0
    copy:
    .for (var i=0; i<25; i++) {
        lda from+(i*offset), y
        sta to+(i*40), y
    }
    iny
    cpy #40
    beq end
    jmp copy
    end:
}

// .size = 84 Bytes
.macro QuickSetColorRam(color) {
    ldy #0
    lda #color
    copy:
    .for (var i=0; i<25; i++) {
        sta colorram+(i*40), y
    }
    iny
    cpy #40
    beq end
    jmp copy
    end:
}

.macro QuickSetColorRamFromA() {
    ldy #0
    copy:
    .for (var i=0; i<25; i++) {
        sta colorram+(i*40), y
    }
    iny
    cpy #40
    beq end
    jmp copy
    end:
}


/**
  Copies the last 24 columns of screen1 to screen3
*/
.macro CopyScreen_1Leftcolumn(src, trgt) {
        ldx #39
        copy:
        .for (var i=0; i<25; i++) {
                lda (src)+(i*40), x
                sta (trgt)+(i*40)-1, x
        }
        dex
        beq end
        jmp copy
        end:
}

/**
  Copies the first 24 columns of screen1 to screen3
*/
.macro CopyScreen_1Rightcolumn(src, trgt) {
        ldy #38
        copy:
        .for (var i=0; i<25; i++) {
                lda (src)+(i*40), y
                sta (trgt)+(i*40)+1, y
        }
        dey
        bmi end
        jmp copy
        end:
}

// Screen pointer for copy
.var map_column = $08
.var screen_pointer_dest = $0a

/**
        Get column from map and add to screen right side
        JSR into this routine!
*/
.macro PrintColumnToScreen_backup(mapsize) {
        .var screen_pointer = $06
        
        Copy16Bit(mapPointer, screen_pointer) //Copy start of map to pointer
        Add16BitTo(screen_pointer, map_column, screen_pointer) //Add column offset to pointer
        ldy #0

        ldx #25
render_next_block:
        lda (screen_pointer), y //Load character from map
        sta (screen_pointer_dest), y //Store character to screen
        AddMemTo16Bit(screen_pointer, mapsize, screen_pointer) //Add map size to pointer
        AddMemTo16Bit(screen_pointer_dest, 40, screen_pointer_dest) //Add map size to pointer
        dex
        bne render_next_block
        rts
}

.macro PrintColumnToScreen(mapsize) {
        // Get current column
        // load first byte of column
        // add maplength to pointer each time
        // repeat for screen height (25)

        // Load current position into temp. 16bit pointer

        ldx #25 //Row counter
        // Load byte from pointer
        ldy #0
copy:        
        lda (map_column),y
        sta (screen_pointer_dest),y
        AddMem16BitTo(screen_pointer_dest,40,screen_pointer_dest) //Add 40 to screen pointer
        AddMem16BitTo(map_column,mapsize,map_column) //Add 40 to screen pointer
        dex
        bne copy
}

.macro PrintRowToScreen(mapsize) {
        // Get current row
        // load first byte of row
        // add 1 to pointer each time
        // repeat for screen width (40)

        // Load current position into temp. 16bit pointer

        ldx #40 //Column counter
        // Load byte from pointer
        ldy #0
copy:        
        lda (map_column),y
        sta (screen_pointer_dest),y
        iny
        dex
        bne copy
}


/** 0=black, 1=white, 2=red, 3=cyan, 4=purple, 5=green, 6=blue, 7=yellow, 
    8=light brown, 9=brown, 10=light red, 11=dark grey, 12=grey, 13=light green, 14=light blue, 15=light grey
 */
.macro setColors(bg0, bg1, bg2) {
        lda #bg0
        sta $d021
        lda #bg1
        sta $d022
        lda #bg2
        sta $d023       
}

// Set ScreenColor to Attributes of Screen
.macro copyColor(screenram, colormap) {
        lda #<screenram
        sta src+1
        lda #>screenram
        sta src+2

        lda #<colorram
        sta tgt+1
        lda #>colorram
        sta tgt+2


src:    ldy screenram
col:    lda colormap,y
tgt:    sta colorram

// Increase target
!:      inc tgt+1
        bne !+
        inc tgt+2

// Increase source        
!:      inc src+1
        bne !+
        inc src+2

!:      lda src+1
        cmp #$E7    // End of Screen
        bcc src
        lda src+2
        cmp #$07    // End of Screen
        bne src
}

// Schifts the whole screen @ $0400 up a line
.macro ShiftScreenUp_OLD() {
// Load character from screen and put up a line
lda #$04
sta src+2
sta tgt+2
lda #$00
sta tgt+1
//sta ctgt+1
lda #$28
sta src+1
//sta csrc+1
//lda #$d8
//sta csrc+2
//sta ctgt+2

src:    lda $ffff //0428 1024+40
tgt:    sta $ffff //0400 1024
//csrc:   lda $ffff //d828
//ctgt:   sta $ffff //d800

// increase position
        inc src+1
        //inc csrc+1
        bne !+
        inc src+2
        //inc csrc+2
!:      inc tgt+1
        //inc ctgt+1
        bne !+
        inc tgt+2
        //inc ctgt+2

// Check if end of screen
!:      lda src+2
        cmp #$07
        bne src
        lda src+1
        cmp #$e8
        bne src
}


.macro ShiftScreenDown() {
    ldy #40
    print:
    .for (var i=24; i>=1; i--) {
        // Screen
        lda $0400+((i-1)*40),y
        sta $0400+(i*40),y
        // ColorMap
        //lda $d800+(i*40),y
        //sta $d800+(i*40),y
    }
    dey
    bmi end
    jmp print
    end:
}

.macro ShiftScreenUp() {
    ldy #40
    print:
    .for (var i=0; i<=23; i++) {
        // Screen
        lda $0400+((i+1)*40),y
        sta $0400+(i*40),y
        // ColorMap
        //lda $d800+(i*40),y
        //sta $d800+(i*40),y
    }
    dey
    bmi end
    jmp print
    end:
}

// Shifts the whole screen @ $0400 down a line
.macro ShiftScreenDown_OLD() {
// Load character from screen and put up a line
lda #$07
sta src+2
sta tgt+2
lda #$e7
sta tgt+1
sta ctgt+1
lda #$bf
sta src+1
sta csrc+1
lda #$db
sta csrc+2
sta ctgt+2

src:    lda $ffff //07e7
tgt:    sta $ffff //07bf
csrc:   lda $ffff //dbe7
ctgt:   sta $ffff //dbbf

// decrease position
        dec src+1
        dec csrc+1
        bne !+
        dec src+2
        dec csrc+2
!:      dec tgt+1
        dec ctgt+1
        bne !+
        dec tgt+2
        dec ctgt+2

// Check if end of screen
!:      lda src+2
        cmp #$03
        bne src
        lda src+1
        cmp #$ff
        bne src
}

// Shifts the whole screen @ $0400 left a column
.macro ShiftScreenLeft() {
        .var multiplier = 25
        .if (multiplier <= 0) { .eval multiplier = 1 }
        ldy #0
        copy:
        .for (var i=0; i<multiplier; i++) {
                // Screen
                lda $0401+(i*40), y
                sta $0400+(i*40), y
                // ColorMap
                //lda $d801+(i*40), y
                //sta $d800+(i*40), y
        }
        iny
        cpy #40
        beq end
        jmp copy
        end:
}

// Shifts the whole screen @ $0400 right a column
.macro ShiftScreenRight() {
        .var multiplier = 25
        .if (multiplier <= 0) { .eval multiplier = 1 }
        ldy #39
        copy:
        .for (var i=0; i<multiplier; i++) {
                // Screen
                lda $0400+(i*40), y
                sta $0401+(i*40), y
                // ColorMap
                //lda $d800+(i*40), y
                //sta $d801+(i*40), y
        }
        dey
        //cpy #0
        beq end
        jmp copy
        end:
}
