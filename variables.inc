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
;CURRENT_ROW_X = $00
;CURRENT_ROW_Y = $00

; Colors
TITLE_COLORS = $B1
PATTERN_ROW_NUMBER_COLOR = $B1
PATTERN_NOTE_COLOR = $B1
PATTERN_VOL_COLOR = $B5
PATTERN_EFX_COLOR = $B8

PATTERN_PLAY_POS = $28    ; Position 40 (halfway down the pattern section)


;SPEED = $40                ; how many vblanks to do nothing for
SPEED = $06                ; how many vblanks to do nothing for
ROW_MAX = $40               ; Max # of rows for our test pattern (64)
UPPERCASE = $8E
PETSCII_DASH = $2D
PETSCII_PERIOD = $2E
PETSCII_UP_ARROW = $5E

NOTEREL  = $0D
NOTEOFF  = $0E
NOTENULL = $0F

OCTAVE = $0C  ; 12

; Zero Page Addresses
VBLANK_SKIP_COUNT = $21    ; Count of current VBLANK skip
ROW_COUNT = $22
PREVIOUS_ISR_HANDLER = $24
STRING_POINTER = $26

NOTE_NOTE = $30
NOTE_OCTAVE = $31
NOTE_NUMERIC = $32

;MAP0 = $00
;MAP1 = $40 ; This is include, tilebase is at 7C by default
;MAP2 = $80
;MAP3 = $C0
