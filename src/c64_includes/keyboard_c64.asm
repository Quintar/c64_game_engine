.macro getKeyboard(keyboardInput) {
        //Keyboard input
        jsr SCNKEY
        jsr GETIN
        sta keyboardInput
}