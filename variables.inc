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
PATTERN_POINTER = $A000
SCREEN_X     = $A0    ; 80 * 2 (char + color)
SCREEN_Y     = $3F    ; 60
SONG_TITLE_X = $09
SONG_TITLE_Y = $01
AUTHOR_TITLE_X = $09
AUTHOR_TITLE_Y = $02

CURRENT_PATTERN_DISPLAY_X = $21
CURRENT_PATTERN_DISPLAY_Y = $02
CURRENT_ROW_DISPLAY_X = $29
CURRENT_ROW_DISPLAY_Y = $02
SPEED_DISPLAY_X = $21
SPEED_DISPLAY_Y = $01
NUMBER_OF_ORDERS_DISPLAY_X = $2C
NUMBER_OF_ORDERS_DISPLAY_Y = $01
CURRENT_ORDER_DISPLAY_X = $29
CURRENT_ORDER_DISPLAY_Y = $01

; Colors
TITLE_COLORS = $B1
PATTERN_ROW_NUMBER_COLOR = $01    ; Foreground Only
PATTERN_NOTE_COLOR = $01
PATTERN_INST_COLOR = $0F
PATTERN_VOL_COLOR = $05
PATTERN_EFX_COLOR = $0E
; Background
PATTERN_BACKGROUND_COLOR = $00  ; background only (top nibble)
MAJOR_HIGHLIGHT_COLOR = $C0     ; background only
MINOR_HIGHLIGHT_COLOR = $B0     ; background only

; Scroll offset to send to VERA to start the pattern in the middle
; of the window. Here we are using a negative number.
PATTERN_SCROLL_START_H = $FF
PATTERN_SCROLL_START_L = $00

;NUMBER_OF_CHANNELS = $01
;TOTAL_BYTES_PER_PATTERN = $0140    ; currently 5 * 64 rows
;TOTAL_BYTES_PER_ROW = $05         ; total bytes per row (for skipping rows)
NUMBER_OF_CHANNELS = $02
TOTAL_BYTES_PER_PATTERN = $0280    ; currently 5 bytes * 2 channels * 64 rows
TOTAL_BYTES_PER_ROW = $0A         ; total bytes per row (for skipping rows)


; Temp Vars (these will come from the song file)
;SPEED = $40                ; how many vblanks to do nothing for
;SPEED = $04                ; how many vblanks to do nothing for
SPEED = $03                 ; how many vblanks to do nothing for
;SPEED = $10                ; how many vblanks to do nothing for

ROW_MAX = $40               ; Max # of rows for our test pattern (64)
ROW_MAJOR = $10             ; Every 16 rows
ROW_MINOR = $04             ; Every 4 rows

; Chars
UPPERCASE = $8E
PETSCII_DASH = $2D
PETSCII_PERIOD = $2E
PETSCII_UP_ARROW = $5E
CHAR_DOT = $2E

; Row statuses
NOTEREL  = $0D
NOTEOFF  = $0E
NOTENULL = $0F
VOLNULL  = $FF
INSTNULL = $FF
EFFNULL = $FF

OCTAVE = $0C  ; 12

; Zero Page Addresses
VBLANK_SKIP_COUNT = $21    ; Count of current VBLANK skip
ROW_COUNT = $22
NOTE_NOTE = $23
NOTE_OCTAVE = $24
NOTE_NUMERIC = $25
PATTERN_NUMBER = $26
ORDER_NUMBER = $27
SCROLL_ENABLE = $30


ROW_POINTER = $2A           ; 16-bit address of the row in the pattern
STRING_POINTER = $2C
PREVIOUS_ISR_HANDLER = $2E

; No longer needed, we know where the pattern is ($4000)
;PATTERN_POINTER = $28       ; 16-bit address to the current pattern




;MAP0 = $00
;MAP1 = $40 ; This is include, tilebase is at 7C by default
;MAP2 = $80
;MAP3 = $C0
