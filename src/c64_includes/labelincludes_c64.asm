// Zero Page
//Memory config
.var cpudatadir = $00       // 6510 CPU's data direction I/O port register; 0 = input, 1 = output
.var memorycfg = $01        // memory configuration Bit0=LORAM(RAM=0/BASIC=1), 1=HIRAM(RAM=0/KERNAL=1), 2=CHAREN(CharRom=0/IO=1), 3=Cassette Data Output, 4=Cassette Switch 0=on, 5=Cassette Motor 0=on
.var zeroUnused0 = $02
.var FloatToIntL = $03
.var FloatToIntH = $04
.var IntToFloatL = $05
.var IntToFloatH = $06
.var SearchCharFlag = $07   // Search character/temporary integer during BASIC INT, OR and AND
.var QuoteFoundFlag = $08   // Scan for quote character at end of string during tokenization of BASIC commands.
.var CursorColumn = $09     // Cursor column position after last invocation of BASIC TAB or SPC
.var LoadCondCheck = $0A    // Sets condition for BASIC Interpreter function; 0 = LOAD, 1 = VERIFY
.var DimPointer = $0B       // Input buffer pointer/number of subscripts for DIM, line length for tokenization
.var DefArrySizeFlag = $0C  // Default size of array for DIM
.var VarTypeFlag = $0D      // Variable type; 0 = numeric, 255 = character string
.var NumTypeFlag = $0E      // Numeric variable type flag; 0 = floating-point, 128 = integer
.var GCFlag = $0F           // For LIST, Garbage Collection or tokenization
.var FuncVarFlag = $10      // Distinguishes between user function call or array variable
.var DataEntryFlag = $11    // Designates data entry method; 0 = INPUT, 64 = GET or 152 = READ
.var SignFlag = $12         // Tracks sign of trigonometric function calls (255 in quadrant 2/3 for SIN or TAN or quadrant 1/2 for COS, 0 otherwise), or tracks comparison operator (1 = >, 2 = equals, 4 = <, is bit-field combination)
// ...
.var zeroUnused1 = $FB
.var zeroUnused2 = $FC
.var zeroUnused3 = $FD
.var zeroUnused4 = $FE
.var FloatToAsciiTemp = $FF

//$DC10-$DCFF	56336-56575	The CIA 1 register are mirrored each 16 Bytes
//Joystick
.var joyport2 = $dc00    // Joystickport 2 + Bit 0-7 Keyboard Columns; also 4 Lightpen; Paddles 2..3 Fire buttons, 6..7 Switch control port 1 (%01=Paddles A) or 2 (%10=Paddles B)
.var joyport1 = $dc01    // Joystickport 1 + Bit 0-7 Keyboard Rows; 6 Timer A, 7 Timer B Toggle/Impulse output
.var TimerALow = $dc04
.var TimerAHigh = $dc05
.var TimerBLow = $dc06
.var TimerBHigh = $dc07
.var RTCtenth = $dc08
.var RTCsec = $dc09
.var RTCmin = $dc0a
.var RTChr = $dc0b
.var serialshift = $dc0c
.var irqctrl = $dc0d

//Sprites
.var spritex             = $d000     // Sprite 0 Position X (left/right)
.var spritey             = $d001     // Sprite 0 Position Y (ip/down)
.var spritex1            = $d002     // Sprite 1 Position X (left/right)
.var spritey1            = $d003     // Sprite 1 Position Y (ip/down)
.var spritex2            = $d004     // Sprite 2 Position X (left/right)
.var spritey2            = $d005     // Sprite 2 Position Y (ip/down)
.var spritex3            = $d006     // Sprite 3 Position X (left/right)
.var spritey3            = $d007     // Sprite 3 Position Y (ip/down)
.var spritex4            = $d008     // Sprite 4 Position X (left/right)
.var spritey4            = $d009     // Sprite 4 Position Y (ip/down)
.var spritex5            = $d00A     // Sprite 5 Position X (left/right)
.var spritey5            = $d00B     // Sprite 5 Position Y (ip/down)
.var spritex6            = $d00C     // Sprite 6 Position X (left/right)
.var spritey6            = $d00D     // Sprite 6 Position Y (ip/down)
.var spritex7            = $d00E     // Sprite 7 Position X (left/right)
.var spritey7            = $d00F     // Sprite 7 Position Y (ip/down)
.var spritexsize         = $d017 // Sprite X double height
.var spriteysize         = $d01D // Sprite X dou8ble width
.var spritemulticolor    = $d01c // Multicolor for Sprite X(bit) de-/activate
.var spritemulti1        = $d025 // multicolor 1 / common ambient color
.var spritemulti2        = $d026 // multicolor 2 / common ambient color
.var spriteactive        = $d015 // Sprite X(bit) de-/activate
.var sprites100          = $1900 // Spriteposition 100
.var sprites150          = $2580 // Spriteposition 150
.var sprites200          = $3200 // Spriteposition 200

//Screen
.var viccfg0         = $d011     // VIC configuration Bit 7=8tes Bit Rasterposition// 6=Extended-Color-mode// 5=1Grafikmode/0Textmode// 4=Screen on/off// 3=25Rows// 2-0=scroll Y
.var raster          = $D012     // Rasterposition
.var rasterpos       = $d012     // Rasterposition
.var viccfg1         = $d016     // VIC configuration Bit 7-5=unused// 4=Multi-Color-mode// 3=40 coloumns// 2-0=scroll X
.var asciicfg        = $d018     // Bit 7-4 = screen-memory-Offset// 3-1 = character-address-offset // 0 unused
.var foreground      = $d021     // background color (rotates through all 16 colors)
.var screencolor     = $d021     // background color (rotates through all 16 colors)
.var background      = $d020     // border color (rotates through all 16 colors)
.var bordercolor     = $d020     // border color (rotates through all 16 colors)
.var vicmemorycfg    = $dd00     // Bit 0-1 configure the VIC-memory bank 00=3, 01=2, 10=1, 11=0 // 2-7 are for RS232
.var screen0         = $0000     // Screen-address 0 d018: 0000 XXXX
.var screen1         = $0400     // Screen-address 1 d018: 0001 XXXX (Standard)
.var screen2         = $0800     // Screen-address 2 d018: 0010 XXXX
.var screen3         = $0c00     // Screen-address 3 d018: 0011 XXXX
//  between d018: 0100 XXXX to 0111 XXXX  is the charset ROM
.var screen8         = $2000     // Screen-address 4 d018: 1000 XXXX
.var screen9         = $2400     // Screen-address 5 d018: 1001 XXXX
.var screen10        = $2800     // Screen-address 6 d018: 1010 XXXX

.var screencolr = $d800  // color memory bank
.var colorram = $d800  // color memory bank
.var lowercolorram = $d800+$3c1

.var charram0 = $0000    // space for character RAM 0 d018: XXXX 000X
.var charram1 = $0800    // space for character RAM 1 d018: XXXX 001X
.var charram2 = $1000    // space for character RAM 2 d018: XXXX 010X (ROM!!) (Standard)
.var charram3 = $1800    // space for character RAM 3 d018: XXXX 011X (ROM!!)
.var charram4 = $2000    // space for character RAM 4 d018: XXXX 100X
.var charram5 = $2800    // space for character RAM 5 d018: XXXX 101X
// 3000 = 6, 3800 = 7,
// 4000 = 8(0), 4800 = 9(1), 5000 = 10(2), 5800 = 11(3), 6000 = 12(4), 6800 = 13(5), 7000 = 14(6), 7800 = 15(7),
// 8000 = 16(0), 8800 = 17(1)
.var charram18 = $9000    // space for character RAM ?? d018: XXXX 010X (ROM!!)
.var charram19 = $9800    // space for character RAM ?? d018: XXXX 011X (ROM!!)


.var charrom0 = $1000    // Character ROM 0
.var charrom1 = $1800    // Character ROM 1
.var charrom2 = $9000    // Character ROM 2
.var charrom3 = $9800    // Character ROM 3

.var bitmap0 = $0000     // bitmap memory-Offset 0 d018: XXXX 000X
.var bitmap1 = $2000     // bitmap memory-Offset 1 d018: XXXX 100X

//KERNAL-Routinen
.var ROMCLR   = $e544    // KERNAL Screen löschen
.var TIMERA   = $dc0e    // Timer A
.var SCNKEY     = $ff9f   // scan keyboard - kernal routine
.var GETIN      = $ffe4   // read keyboard buffer - kernal routine

//Interesting Constants
.var screensize = $03f8
.var spritesize = $40

//Colors
.var black       = $00
.var white       = $01
.var red         = $02
.var cyan        = $03
.var purple      = $04
.var green       = $05
.var blue        = $06
.var yellow      = $07
.var orange      = $08
.var brown       = $09
.var lightred    = $0a
.var gray1       = $0b
.var gray2       = $0c
.var lightgreen  = $0d
.var lightblue   = $0e
.var gray3       = $0f