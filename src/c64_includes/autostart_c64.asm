/* Loads a programm to 'start'-2 Bytes and autostarts it.
Remember, all assembled programms have a two bytes starting address, those are written 2 bytes before the real program starts
stores a readfile function in the variable 'readfile'
*/
.macro autostart(start, progfilename, nobasic) {
    .segment Autostart[] "Autostart"
    * = $326	//DO NOT CHANGE, else the autostart will fail

    .word boot	//autostart from charout vector ($f1ca)
    .word $f6ed	//$328 kernal stop routine Vector ($f6ed)
    .word $f13e	//$32a kernal getin routine ($f13e)
    .word $f32f	//$32c kernal clall routine vector ($f32f)
    .word $fe66	//$32e user-defined vector ($fe66)
    .word $f4a5	//$330 kernal load routine ($f4a5)
    .word $f5ed	//$332 kernal save routine ($f5ed)

    //* = $334 (cassette buffer)

boot:	RepairCharOutVector()
        .if (nobasic != 0) {
            lda #$37	//unload BASIC rom
            sta $01
        }
        ReadFileJumpTo(progfilename, start-2, start)
//rfile: ReadFile($0400)
//.eval readfile = rfile
}

// RepairCharOutVector
// .size = 11 bytes
.macro RepairCharOutVector() {
    sei
    lda #$ca	//repair charout vector ($f1ca)
    sta $326
    lda #$f1
    sta $327
}
