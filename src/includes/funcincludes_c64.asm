#import "labelincludes_c64.asm"
//#import "stack.asm"
#import "file_c64.asm"
#import "autostart_c64.asm"
#import "math.asm"
//#import "screen_c64.asm"
//#import "scroll_c64.asm"
//#import "raster_c64.asm"
//#import "map_c64.asm"
#import "memmanipulation.asm"
//#import "sprites_c64.asm"
//#import "keyboard_c64.asm"

.macro assemblyInfo(start, end, spriteoffset) {
    .print "Zero Page $0000 - $00ff"
    .print "Stack Vektoren $0100 - $01ff"
    .print "BASIC Eingabepuffer $0200 - $0258"
    .print "BASIC Vektoren $0300 - $03ff"
    .print "Screen Memory $0400 - $07ff"
    .print "BASIC Prg Start $0800"
    .print "Programm Offset: $" + toHexString(start) + " - $" + toHexString(end)
    .print "Programm Size: " + (end - start) + " Byte"
    .print "FREE Space from $" + toHexString(end) + " to $d7ff = " + ($d7ff - end) + " Bytes"
    .print "Sprite offset: $" + toHexString(spriteoffset * 64)
    .print "Color ram $d800 - $dbff"
    .print "CIA 1 and 2 $dc00 - $ddff"
    .print "KERNAL ROM $e000 - $ffff"
}


// Counts down from 'number' (writing into 'temptimer') and jumping to 'endcheck' if counter not 0
.macro CountDownFrom(number, temptimer, endcheck) {
    // Wait for control timer to run out
    dec temptimer
    bne endcheck
    lda #number
    sta temptimer
}