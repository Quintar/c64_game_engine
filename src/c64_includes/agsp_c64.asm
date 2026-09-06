.macro irqAGSP() {
.var border=$d021
.var field1=$01
.var field2=$02
.var fldcnt=$03
.var afa=$04
.var afb=$05
.var vspcnt=$06
.var ypos=$07
.var xpos=$08


    pha
    txa
    pha
    tya
    pha

    lda #$03    // VIC-Adressraum auf $0000-$3fff schalten
    sta $dd00

    dec $d019   // IRQ-ICR freigeben

    lda #$1d    // Nächster Raster-IRQ bei Zeile: 1d = 29
    sta $d012

    lda #<irqGlatt
    sta $fffe

    lda #>irqGlatt
    sta $ffff

    cli

!:  // 23 NOPs
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    bne !-

cycles:
    rts

irqGlatt:
    pla
    pla
    pla

    dec $d019

    lda #$f8
    sta $d012

    lda #<border
    sta $fffe

    lda #>border
    sta $ffff

    lda #$c8    // 40 Zeichen darstellung
    sta $d016

    lda #$06    // Video-RAM nach $0000 verschieben
    sta $d018

    nop

    lda $d012
    cmp #$1d
    beq line

line:
    lda #$00    // Bildschirm und Rahmen auf schwarz schalten
    sta $d020
    sta $d021

    jsr cycles  // 3*12 Zyklen verzögern
    jsr cycles
    jsr cycles
    bit $ea     // 3 Zyklen verzögern

fld:
    ldx #$27
    ldy #$01
fldlp:
    jsr cycles

    lda field1, y
    sta $d011

    lda field2, y
    sta $d018

    nop
    nop
    nop

    iny
    dex
    cpy <fldcnt
    bne fldlp

    nop
    jsr cycles

    lda field2, y
    iny
    sta $d018

vsp:
    inx
    stx <vspcnt
    nop
    nop
    nop
    nop
vsplp:
    nop
    nop
    nop
    nop

    ldx field1+3, y
    stx $d011

    nop
    nop
    nop

    lda field2, y
    sta $d018

    nop
    nop

    iny
    dec <vspcnt

    bne vsplp
    bit $ea
    nop
    nop

hsp:
    ldx field1+3, y
    stx $d011
    jsr cycles

    dex
redu1: beq redu2
redu2: bne tt
    // 20 NOPs
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

tt: stx $d011

horizo:
    lda $00
    sta $d016

vertic:
    lda #$00
    sta $d011

    ldx #$57
!:
    dex
    bne !-

    ldy #$17
    sty $d018

    lda $d011
    and #$1f
    sta $d011

    lda #$0e
    sta $d020

    lda #$06
    sta $d021

    pla
    tay
    pla
    tax
    pla
    rti

controll:
    lda <ypos
    lsr
    lsr
    lsr
    sta <fldcnt
    clc
    lda <ypos
    and #$07
    eor #$07
    adc #$1a
    and #$07
    ora #$18
    sta vertic+1

    ldx #$d0     // Opcode für "BNE" in
    stx redu1    //  REDU1 eintragen
    lda <xpos+1  // Hi-Byte XPos holen
    sta <afb     //  und nach AFB kop.
    lda <xpos    // Lo-Byte XPos holen
    sta <afa     //  nach AFA kop.
    and #$08
    bne co1
    ldx #$f0
    stx redu1

co1:
    lsr <afb
    ror <afa
    lsr <afb
    ror <afa
    lsr <afb
    ror <afa
    lsr <afb
    ror <afa
    sec
    lda #$14
    sbc <afa
    sta redu2+1

    lda <xpos
    and #$07
    ora #$08
    sta horizo+1
    rts


}
