.segment ProgStart[outPrg="c64ge.prg"] "Programm Start"
*=$0803
begin: 
lda #1
sta $d020
loop:    jmp loop