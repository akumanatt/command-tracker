; Variables
; VERA Settings
VBLANK_MASK  = %00000001
RES128x64x256 = %01101000
RES128x128x256  = %10101000
RES128x64x16  = %01100000
RES128x128x16  = %10100000

; Field : Sprit E : L1 E : L2 E : NC : Chroma : Output x2
DC_VIDEO = %00110001

; Kernel Locations
ISR_HANDLER = $0314

; Constants
SCREEN_X     = $A0    ; 80 * 2 (char + color)
SCREEN_Y     = $3F    ; 60
SONG_TITLE_X = $09
SONG_TITLE_Y = $01
AUTHOR_TITLE_X = $09
AUTHOR_TITLE_Y = $02
CURRENT_ROW_X = $29
CURRENT_ROW_Y = $02

; Colors
TITLE_COLORS = $B1
PATTERN_ROW_NUMBER_COLOR = $B1
PATTERN_NOTE_COLOR = $B1
PATTERN_VOL_COLOR = $B5
PATTERN_EFX_COLOR = $B8

; Characters
CHAR_DOT = $2E

; Scroll offset to send to VERA to start the pattern in the middle
; of the window. Here we are using a negative number.
PATTERN_SCROLL_START_H = $FF
PATTERN_SCROLL_START_L = $00

TOTAL_BYTES_PER_ROW = $02         ; total bytes per row (for skipping rows)

;SPEED = $40                ; how many vblanks to do nothing for
SPEED = $06                ; how many vblanks to do nothing for
;SPEED = $10                ; how many vblanks to do nothing for
ROW_MAX = $40               ; Max # of rows for our test pattern (64)
UPPERCASE = $8E
PETSCII_DASH = $2D
PETSCII_PERIOD = $2E
PETSCII_UP_ARROW = $5E

NOTEREL  = $0D
NOTEOFF  = $0E
NOTENULL = $0F
VOLNULL  = $FF

OCTAVE = $0C  ; 12

; Zero Page Addresses
VBLANK_SKIP_COUNT = $21    ; Count of current VBLANK skip
ROW_COUNT = $22
NOTE_NOTE = $23
NOTE_OCTAVE = $24
NOTE_NUMERIC = $25
PATTERN_POINTER = $26       ; 16-bit address to the current pattern
ROW_POINTER = $28           ; 16-bit address of the row in the pattern
STRING_POINTER = $2A
PREVIOUS_ISR_HANDLER = $2C






;MAP0 = $00
;MAP1 = $40 ; This is include, tilebase is at 7C by default
;MAP2 = $80
;MAP3 = $C0
