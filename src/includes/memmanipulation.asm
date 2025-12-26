.macro DeactivateBasic() {
    // Set BASIC off
    lda #%11111110
    sta $01 //memcfg
}


// Simple Copy of Data 'from' 'to' for 'size'
.macro Copy(from, to, size) {
load:   lda from
save:   sta to
        inc load+1
        bne insave
        inc load+2
insave: inc save+1
        bne chksize
        inc save+2

chksize:dec siz
        bne load
        .if (size > $ff) {
            dec siz+1
            bne load    
        }
        jmp end
siz:    .word size
end:    
}

.var CopyToTimesLow=   $FB //zeroUnused1
.var CopyToTimesHigh=  $FC //zeroUnused2
.var CopyToLineOffset= $FD //zeroUnused3
.var CopyToLineLength= $FE //zeroUnused4

.macro SetupQuickCopy(source, target, length, mapLengthAfterScreenLine) {
        lda #<source
        sta src+1
        lda #>source
        sta src+2
        lda #<target
        sta tgt+1
        lda #>target
        sta tgt+2
        lda #<length //Screensize in Characters
        sta zeroUnused1
        lda #>length //Screensize in Characters
        sta zeroUnused2
        lda #mapLengthAfterScreenLine //mapLength - LineLength
        sta zeroUnused3
        lda #40 //Screen-Line length
        sta zeroUnused4
        tax

}

// Set src to source and target to target, 
// the code is self modifying so it needs to be reset each time
// 4+4+2+2+6+2+6+2+6+2=36*40=1440 = 2.9lines (complete with H-Blank < 504*8=4032)
// 4+4+2+2+ (2+2+4+3+4+2=17) (- 6+2+6=14) +3 (every full line)
// = 1443 Cycles per 40-character-line = ~3 Raster-Lines
.macro CopyTo() {    
    @src:    lda $ffff  //set to source 4
    @tgt:    sta $ffff  //set to target 4

    dex                               //2
    bne incSource                     //2
    ldx CopyToLineLength //default line length      2
    clc //Add LineOffset to source after each line  2
    lda src+1                         //4
    adc CopyToLineOffset              //3
    sta src+1                         //4
    bcc incTrgt                       //2
    inc src+2                         //6
    jmp incTrgt                       //3

incSource: inc src+1                  //6
    bne incTrgt                       //2
    inc src+2                         //6
incTrgt: inc tgt+1                    //6
    bne decTimer                      //2
    inc tgt+2                         //6

decTimer:    dec CopyToTimesLow       //6
    bne src                           //2
    dec CopyToTimesHigh               //6
    bne src                           //2
}


/*
Copies data 'from' 'to' for 'count' (max = 255) bytes times 'multiplier'. 'offset' is the offset between copy lines.

Example for a full screen left shift:
QuickCopy($0401, $0400, 40, 25, 40)
where
QuickCopy(from, to, columns, lines, linelength)
or shift just 1 column in from a map to screen
QuickCopy(from, to, 1, 25, 40)
or shift just 1 line from a map to screen
QuickCopy(from, to, 1, 40, 1)
*/
.macro QuickCopy(from, to, count, multi, offset) {
    .var multiplier = multi
    .if (multiplier <= 0) { .eval multiplier = 1 }
    ldy #0
    copy:
    .for (var i=0; i<multiplier; i++) {
        lda from+(i*offset), y
        sta to+(i*offset), y
    }
    iny
    cpy #count
    beq end
    jmp copy
    end:
}

// Copies a string (0 ended) 'from' memory position, 'to' another memory position
// .size = 30 bytes
.macro CopyString(from, to) {
        load:   lda from
                beq end
        save:   sta to
                inc load+1
                bne insave
                inc load+2
        insave: inc save+1
                bne load
                inc save+2
                jmp load
        end:    
}

// Puts the string length (no more than 255) into a register
// GetStringLength.size = 13
.macro GetStringLength(string) {
         ldy #0
startfn: lda string,y
         beq endfn
         iny
         jmp startfn
endfn:   tya
}

