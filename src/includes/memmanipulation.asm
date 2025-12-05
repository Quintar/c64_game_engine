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

