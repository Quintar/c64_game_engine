// Raster timings
.var onCharScreen = 50
.var onCharScreenEnd = onCharScreen + 200
.var onVBlankStart = 300
.var onVBlankEnd = 312

.macro RasterInterrupt() {
@doRaster:
    inc lowState
    lda lowState
    cmp #stateLogic+1
    bne !+
    lda #StateKeyboard
    sta lowState
!:
    EndRaster()
}
