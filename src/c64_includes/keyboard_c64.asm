
// Reads the last typed key from the keyboard buffer into the given variable or just A register
// Usage: getKeyboard(variable) or getKeyboard(0) to just get it in A
.macro getKeyboard(saveTo) {
        //Keyboard input
        //jsr SCNKEY
        //jsr GETIN
        lda $cb
        .if (saveTo > 0) sta saveTo
}

.macro setupKeyboard(delay, repeat) {
        lda #delay                  // Set keyboard buffer size to 1
        sta maxKeyBuffer        
        lda repeat                 // all keys repeat
        sta keyRepeatSwitch     // disable key repeat
    }

// Returns the keycode for the given key
.function withKey(key) {
    .if(key >= 'a') .return key
    .return key+48
}