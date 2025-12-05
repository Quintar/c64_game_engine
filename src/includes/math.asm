// Sets a 16bit value to a 16bit destination address
.macro Set16Bit(value, dest) {
        lda #<value
        sta dest
        lda #>value
        sta dest+1
}

// Copies a 16bit value from 'from' to 'to'
.macro Copy16Bit(from, to) {
        lda from
        sta to
        lda from+1
        sta to+1
}

// Adds two 16bit values and stores the result in 'result' (n1 + n2) -> result
.macro Add16Bit(n1, n2, result) {
        clc
        lda #<n1
        adc #<n2
        sta result
        lda #>n1
        adc #>n2
        sta result+1
}

// Adds two 16bit values and stores the result in 'result' (mem1 + n2 -> result)
.macro AddMem16BitTo(mem1, n2, result) {
        clc
        lda mem1
        adc #<n2
        sta result
        lda mem1+1
        adc #>n2
        sta result+1
}

// Adds two 16bit values and stores the result in 'result' (mem1 + n2 -> result)
.macro AddMemTo16Bit(mem1, n2, result) {
        clc
        lda mem1
        adc #n2
        sta result
        lda mem1+1
        bcc skip
        adc #1
//        lda mem1+1
//        adc #>n2
skip:    sta result+1
}

.macro SubMem16BitTo(mem1, n2, result) {
        sec
        lda mem1
        sbc #<n2
        sta result
        lda mem1+1
        sbc #>n2
        sta result+1
}

// Adds two 16bit values from memory and stores the result in 'result'
.macro Add16BitTo(mem1, mem2, result) {
        clc
        lda mem1
        adc mem2
        sta result
        lda mem1+1
        adc mem2+1
        sta result+1
}
