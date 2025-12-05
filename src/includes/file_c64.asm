.var filenamepointer = $17
.var filetgtpointer = $19
.var jmptopointer = $22

.macro SetNam() {
        sta $b7
        stx $bb
        sty $bc
        //rts
}

.macro SetFs() {
        sta $b8
        stx $ba
        sty $b9
        //rts
}
/* 
    Set 16bit adress a to filenamepointer
    Set 16bit adress b to filetgtpointer
    Set 16bit adress c to jmptopointer
*/
.macro SetPointers(a, b, c) {
    lda #<a
    sta filenamepointer
    lda #>a
    sta filenamepointer+1

    lda #<b
    sta filetgtpointer
    lda #>b
    sta filetgtpointer+1

    lda #<c
    sta jmptopointer
    lda #>c
    sta jmptopointer+1
}


/**
    Reads a file with 
    filename - 0 terminated string-16bit address
    file - 16 bit adress of the memory position
    jmpto - program pointer set to this 16bit position
    //readfile-  is the ReadFile function-16bit address
    ReadFileJumpTo.size = 39 + 3 = 41 Bytes
 */
.macro ReadFileJumpTo(filename, file, jmpto) {
    //SetPointers(filename, file, jmpto)    
    //jmp readfile

    FileLoad(filename, file, 8)
    jmp jmpto
}


/**
 * filename - is a 16bit address to the ",s" terminated string
 * namesize - is the size of the filename in byte
 * filepos - is the 16bit adress on where to load the file into memory
 * devadr - is the device identifier (8,9,10,11)
 * FileLoad.size = 69 + 13 = 82 bytes
 */
.macro FileLoad(filename,filepos,devadr) {
        //Set Logical File
        lda #$01
        ldx #devadr
        ldy #$00
        jsr $ffba //SETLFS

        // Set File Name
        GetStringLength(filename)
        //lda #namesize
        ldx #<filename
        ldy #>filename
        jsr $ffbd //SETNAM

        // Load File
        //lda #$00
        //ldx #<filepos
        //ldy #>filepos
        //jsr $ffd5 //LOADFILE

        clc
        jsr $ffc0 // OPEN
        bcs eof

        ldx #01    // filenumber
        jsr $ffc6 // CHKIN

        lda #<filepos
        sta filetgtpointer
        lda #>filepos
        sta filetgtpointer+1
        ldy #0
        loop:   inc background //scrool background 
                jsr $ffb7 // call readst
                bne eof
                jsr $ffcf // call chrin
                sta (filetgtpointer),y
                inc filetgtpointer
                bne skip2
                inc filetgtpointer+1
        skip2:  jmp loop
        eof:
        close:
        lda #1
        jsr $ffc3 // call close
        jsr $ffcc // call clrchn        
}

/** reads a file at (filename) (0 terminated) from last use device
  * writes content at (file)-position
  * jumps to jmpto
  * 
  * use this only once in your program
  */
.macro ReadFile(errormsg) {
         ldy #0
        startfn:  lda (filenamepointer),y
                beq endfn
                iny
                jmp startfn
        endfn:    tya

                ldx filenamepointer
                ldy filenamepointer+1
                jsr $ffbd //call setnam

                lda #2    // filenumber
                ldx $ba   // last device
                bne skip
                ldx #8
        skip:     ldy #2   // sec. address
                jsr $ffba // call setfs

                clc
                jsr $ffc0 // call open
                bcs error

                ldx #2    // filenumber
                jsr $ffc6 // call chkin


                ldy #0
        loop:    inc background //scrool background 
                jsr $ffb7 // call readst
                bne eof
                jsr $ffcf // call chrin
                sta (filetgtpointer),y
                //sta $04a0,y
                inc filetgtpointer
                bne skip2
                inc filetgtpointer+1
        skip2:   jmp loop

        eof:      beq error

        close:
                lda #2
                jsr $ffc3 // call close
                jsr $ffcc // call clrchn

                lda #0
                sta (filetgtpointer),y
                jmp (jmptopointer)

        readerror: jsr $ffb7
        error:    sta errormsg
                jmp close    
}