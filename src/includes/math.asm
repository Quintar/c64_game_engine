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

// Multiplies 2 8Bit values (mul1 * mul2) and stores the 16bit result in 'result'
.macro Mul16Bit(mul1, mul2, result) {
        lda #0
        sta result
        sta result+1

        lda #mul1
        ldy #mul2
mulloop:
        dey
        beq mulend
        clc
        adc #mul1
        bcs mulcarry
        jmp mulloop
mulcarry:
        inc result+1
        jmp mulloop
mulend:
        sta result
}

// Divide 2 8Bit numbers (div1 / div2) and stores the 8bit result in 'result', rest is in accumulator
.macro Div8Bit(div1, div2, result) {
        lda #0
        sta result
        
        lda #div1
        sec
divloop:
        sbc #div2
        bcc divend
        inc result
        jmp divloop
divend:
        adc #div2
}

/*** Divide 2 8Bit numbers (div1 / div2) 
 and stores the 8bit result in accumulator, 
 rest/modulo is in x-register
***/
.macro Div8BitAcc(div1, div2, result) {
        lda #div1
        sec
divloop:
        sbc #div2
        bcc divend
        iny
        jmp divloop
divend:
        adc #div2
        tax
        tya
}