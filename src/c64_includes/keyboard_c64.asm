.var CurrentKey = $cb          // Last key pressed


// Reads the last typed key from the keyboard buffer into the given variable or just A register
// Usage: getKeyboard(variable) or getKeyboard(0) to just get it in A
.macro getKeyboard(saveTo) {
        //Keyboard input
        //jsr SCNKEY
        //jsr GETIN
        lda CurrentKey
        .if (saveTo > 0) sta saveTo
}

.macro setupKeyboard(delay, repeat) {
        lda #delay                  // Set keyboard buffer size to 1
        sta maxKeyBuffer        
        lda repeat                 // all keys repeat
        sta keyRepeatSwitch     // disable key repeat
    }



// Returns the hardware keycode for the given key read from $cb keyboard buffer.
// use lowercase letters for a-z, numbers for 0-9 and "f1", "f3", "f5", "f7", 
// "return", "crsud" (cursor up), "crslr" (cursor left), "<-" (backspace), "run", "clr" for special keys. Returns 255 if the key is not recognized.
.function withKey(key) {
    .if(key == "a") .return 10
    .if(key == "b") .return 28
    .if(key == "c") .return 20
    .if(key == "d") .return 18
    .if(key == "e") .return 14
    .if(key == "f") .return 21
    .if(key == "g") .return 26
    .if(key == "h") .return 29
    .if(key == "i") .return 33
    .if(key == "j") .return 34
    .if(key == "k") .return 37
    .if(key == "l") .return 42
    .if(key == "m") .return 36
    .if(key == "n") .return 39
    .if(key == "o") .return 38
    .if(key == "p") .return 41
    .if(key == "q") .return 62
    .if(key == "r") .return 17
    .if(key == "s") .return 13
    .if(key == "t") .return 22
    .if(key == "u") .return 30
    .if(key == "v") .return 31
    .if(key == "w") .return 9
    .if(key == "x") .return 23
    .if(key == "y") .return 25
    .if(key == "z") .return 12

    .if(key == "1") .return 56
    .if(key == "2") .return 59
    .if(key == "3") .return 8
    .if(key == "4") .return 11
    .if(key == "5") .return 16
    .if(key == "6") .return 19
    .if(key == "7") .return 24
    .if(key == "8") .return 27
    .if(key == "9") .return 32
    .if(key == "0") .return 35

    .if(key == " ") .return 60
    .if(key == "f1") .return 4
    .if(key == "f3") .return 5
    .if(key == "f5") .return 6
    .if(key == "f7") .return 3
    
    .if(key == "return") .return 1
    .if(key == "crsud") .return 7
    .if(key == "crslr") .return 2
    .if(key == "<-") .return 57
    .if(key == "run") .return 63
    .if(key == "clr") .return 51
    
    .return 255
}