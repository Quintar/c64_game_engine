// Scroll by x (0-7) pixel right
.macro ScrollX(x) {
    lda viccfg1
    and #%11111000
    ora #x
    sta viccfg1
}

// Scroll by y (0-7) pixel down
.macro ScrollY(y) {
    lda viccfg0
    and #%11111000
    ora #y
    sta viccfg0
}

.macro ScrollYUp() {
    lda viccfg0
    and #%11111000
    sta viccfg0

    lda ScrollUp
    and #7
    ora viccfg0
    sta viccfg0
}

// Scroll by x(right), y(down) pixel (0-7)
.macro ScrollXY(x, y) {
    ScrollY(y)
    ScrollX(x)
}

