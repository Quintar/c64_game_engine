// Jumps to onhitjump when raster line hits 'hitline'
.macro RasterHit(hitline, onhitjumto) {
    .var xline = hitline
    .if (hitline > 255){ .eval xline = hitline - 256 }
    // Check for Rasterline Position
    lda $d012
    cmp #xline
    bne DontRasterHit
    // Check for 8th bit Rasterline set
    lda $d011       // VIC-Chip
    asl
    .if (hitline > 255){
        bne DontRasterHit
    } else {
        beq DontRasterHit
    }
    jsr onhitjumto
    DontRasterHit:
}

// Call this function first to initialize your own raster routine
.macro InitRaster() {
    sei                  // set interrupt bit, make the CPU ignore interrupt requests
    lda #%01111111       // switch off interrupt signals from CIA-1
    sta $DC0D

    and $D011            // clear most significant bit of VIC's raster register
    sta $D011

    lda $DC0D            // acknowledge pending interrupts from CIA-1
    lda $DD0D            // acknowledge pending interrupts from CIA-2
    cli                  // clear interrupt flag, allowing the CPU to respond to interrupt requests
}

// Call this function to prepare raster interrupt on rasterline "hitline" and jump to "onhitjmpto"
.macro OnRaster(hitline, onhitjmpto) {
    .var xline = hitline
    .if (hitline > 255){ .eval xline = hitline - 256 }
    lda #xline           // set rasterline where interrupt shall occur
    sta $D012
    .if (hitline > 255) {
        lda #%10000000
        ora $D011
    } else {
        lda #%01111111
        and $D011
    }
    sta $D011

    lda #<onhitjmpto      // set interrupt vectors, pointing to interrupt service routine below
    sta $0314
    lda #>onhitjmpto
    sta $0315

    lda #%00000001       // enable raster interrupt signals from VIC
    sta $D01A
}

// Call this function at the end of the raster interrupt routine, no rts required.
.macro EndRaster() {
    asl $D019            // acknowledge the interrupt by clearing the VIC's interrupt flag
    jmp $EA31            // jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.
}