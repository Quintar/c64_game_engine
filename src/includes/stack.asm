// Pushes A,X,Y onto stack
.macro pushStack() {
    pha
    txa
    pha
    tya
    pha
}

// Pulls A,X,Y from stack
.macro pullStack() {
    pla
    tay
    pla
    tay
    pla
}