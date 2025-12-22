// Copies sprite data (64 Bytes) from a location to a location
.macro BuildSprite(from, to){
    // Build the Sprite
    ldx #$00     // init x
build:
    lda from, x  // load data at x
    sta to,x     // write into sprite data at x
    inx          // increment x
    cpx #$3F     // is x <= 63?
    bne build    // if yes, goto build
}

// Check Joystick Port and manipulate 2 sprites  x/y
.macro CheckJoy2Sprites(joy, sprite1y, sprite2y, sprite1x, sprite2x) {
    lda joy
    lsr
    bcs no_up
    dec sprite1y
    dec sprite2y
    no_up:
    lsr
    bcs no_down
    inc sprite1y
    inc sprite2y
    no_down:
    lsr
    bcs no_left
    dec sprite1x
    dec sprite2x
    no_left:
    lsr
    bcs no_right
    inc sprite1x
    inc sprite2x
    no_right:
}

// Check Joystick Port and manipulate 1 sprite x/y
.macro CheckJoy1Sprite(joy, sprite1y, sprite1x) {
    lda joy
    lsr
    bcs no_up
    dec sprite1y
    no_up:
    lsr
    bcs no_down
    inc sprite1y
    no_down:
    lsr
    bcs no_left
    dec sprite1x
    no_left:
    lsr
    bcs no_right
    inc sprite1x
    no_right:
}

// Sets the sprite multi-colors
.macro SetSpriteColors(multicolor1, multicolor2) {
        lda #$ff
        sta spritemulticolor // multicolor activ
        lda #multicolor1 //$08
        sta spritemulti1 // multicolor 1 / Gemeinsame Ambientefarbe
        lda #multicolor2 //$06
        sta spritemulti2 // multicolor 2 / Gemeinsame Ambientefarbe
}

// Activate Sprites
.macro activateSprites(sprites) {
    lda #sprites
    sta spriteactive
}