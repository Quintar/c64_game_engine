.var mapPointer = $17
.var tilePointer = $19
.var screenPointer = $22
.var ScrollUp = $24


// Sets 16Bit [mapPointer], [tilePointer] and [screenPointer]
.macro SetMapPointer(mapp, tile, screen) {
        lda #<mapp
        sta mapPointer
        lda #<tile
        sta tilePointer
        lda #<screen
        sta screenPointer

        lda #>mapp
        sta mapPointer+1
        lda #>tile
        sta tilePointer+1
        lda #>screen
        sta screenPointer+1
}

.macro LoadSetMapPointer(mapp, screen) {
        lda mapp
        sta mapPointer
        lda #<screen
        sta screenPointer

        lda mapp+1
        sta mapPointer+1
        lda #>screen
        sta screenPointer+1
}

// 63 cycles per raster line
// ~4 cycles per command
.macro printUnpackMap(maplength, tilewidth) {
        lda mapPointer
        sta src+1
        lda mapPointer+1
        sta src+2

        lda screenPointer
        sta tgt+1
        lda screenPointer+1
        sta tgt+2

        lda #0
        sta colcount

start:  ldy #0
// Load Char from Tile and Store in Screen
src:    lda $ffff,y
tgt:    sta $ffff,y
// Increase target by 1
!:      iny
// check for Line End
        cpy #40
        bne src

// check for end of Screen
!:      lda tgt+1
        cmp #$E7    // End of Screen
        bcc !+
        lda tgt+2
        cmp #$07    // End of Screen
        bne !+
        rts         // We reached end of screen END

// check if on odd row        
!:      lda colcount
        bne !+ // If second row, add to tile pointer and change row

// Change tile bank
        lda src+2
        clc
        adc #$10
        sta src+2
        inc colcount
        jmp !++ // If first row, don't add to tile pointer or change row
// Reset tile bank
!:      lda src+2
        sec
        sbc #$10
        sta src+2
        dec colcount

// Add maplength*tilewidth to tile pointer for next row
        lda src+1
        clc
        adc #(maplength*tilewidth)
        sta src+1
        bcc !+
        inc src+2

// Add screensize to target pointer for next row
!:      lda tgt+1
        clc
        adc #40
        sta tgt+1
        bcc !+
        inc tgt+2

!:      jmp start

colcount: .word $00
}


/** Unpacks a map 
    in mem:[mapPointer] 
    with tiles in mem:[tilePointer] 
    which have par:[tilesize] 
    of par:[mapsize] 
    to mem:[screenPointer]
*/
.macro unpackMapTo(tilesize, tileheight, mapsize) {
        lda mapPointer
        sta map+1
        lda mapPointer+1
        sta map+2

        lda screenPointer
        sta tgt+1
        lda screenPointer+1
        sta tgt+2

        lda #0
        sta colcount
        sta colcount+1

// Load Tile from Map
start:  lda tilePointer
        sta tile+1
        lda tilePointer+1
        sta tile+2

map:    ldy $ffff
        beq stile
        lda #0
        
mul:    clc
        adc #4
        bcc !+
        inc tile+2
!:      dey
        bne mul

        sta tile+1  // Tiles-Low Byte

// Init Load Char from Tile
stile:  
        ldy #0
        ldx #0
// Load Char from Tile and Store in Screen
tile:   lda $ffff,x
tgt:    sta $ffff,y

// Increase pointer
        iny
        inx

// Check for end of Tile
!:      cpx #2 //(tilesize/tileheight)      // End of Tile-half
        bne !+
        ldy #0
        lda tgt+2               // Save to second bank
        clc
        adc #$10
        sta tgt+2
!:      cpx #4 //tilesize
        bne tile                // Save in first bank again
        ldy #0
        lda tgt+2
        sec
        sbc #$10
        sta tgt+2

// Increase map
!:      inc colcount
        bne !+
        inc colcount+1
!:      inc map+1
        bne !+
        inc map+2

// Increase targetpointers by tile width
!:      clc
        lda tgt+1
        adc #(tilesize/tileheight)
        sta tgt+1
        bcc !+
        inc tgt+2

// check colcount        
!:      lda colcount
        cmp #<mapsize         // Screen Width / Tile Width
        bne start
        lda colcount+1
        cmp #>mapsize
        bne start
        rts
colcount: .word $0000
}

// Prints horizontal map line (40 characters) from mem:[mapPointer] to mem:[screenPointer]
.macro PrintHLine() {
        lda mapPointer
        sta map+1
        lda mapPointer+1
        sta map+2

        lda screenPointer
        sta tgt+1
        lda screenPointer+1
        sta tgt+2
        
        ldy #0
map:    lda $ffff,y
tgt:    sta $ffff,y

        iny
        cpy #40
        bne map
        rts
}

// Prints vertical map line from mem:[mapPointer] to mem:[screenPointer] beginning at row mem:[tilePointer]
.macro PrintVLine(maplength) {
        lda mapPointer
        sta map+1
        lda mapPointer+1
        sta map+2

        lda screenPointer
        sta tgt+1
        lda screenPointer+1
        sta tgt+2

        lda tilePointer
        sta colcount

        ldy #0
        ldx #0
map:    lda $ffff
tgt:    sta $ffff
        
        lda map+1
        adc #maplength
        sta map+1
        bcc !+
        inc map+2
!:      lda colcount
        bne !+
        clc
        lda map+2
        adc #10
        sta map+2
        jmp !++
!:      lda map+2
        sec
        sbc #10
        sta map+2

!:      lda tgt+1
        clc
        adc #40
        sta tgt+1
        bcc !+
        inc tgt+2
!:      iny
        cpy #25
        bne map
        rts    

colcount: .byte $00    
}