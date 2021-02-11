; Variables
; VERA Settings
VBLANK_MASK  = %00000001
RES128x64x256 = %01101000
RES128x128x256  = %10101000
RES128x256x16  = %10111000
RES128x64x16  = %01100000
RES128x128x16  = %10100000
DISPLAY_END_X = $4F
DISPLAY_END_Y = $3B

; Field : Sprit E : L1 E : L2 E : NC : Chroma : Output x2
DC_VIDEO = %00110001

; Kernel Locations
ISR_HANDLER = $0314

; Constants
PATTERN_POINTER = $A000
SCREEN_X     = $A0    ; 80 * 2 (char + color)
SCREEN_Y     = $3F    ; 60

; UI Locations
;; Static Locations for Labels
PROGRAM_TITLE_X = $05
PROGRAM_TITLE_Y = $00

SONG_TITLE_LABEL_X = $01
SONG_TITLE_LABEL_Y = $01
SONG_TITLE_X = $09
SONG_TITLE_Y = $01

COMPOSER_LABEL_X = $01
COMPOSER_LABEL_Y = $02
COMPOSER_X = $09
COMPOSER_Y = $02

SPEED_LABEL_X = $1C
SPEED_LABEL_Y = $01
PATTERN_LABEL_X = $1C
PATTERN_LABEL_Y = $02
ORDER_LABEL_X = $24
ORDER_LABEL_Y = $01
ROW_LABEL_X = $24
ROW_LABEL_Y = $02
ROW_HEADER_X = $01
ROW_HEADER_Y = $08
MORE_CHANNELS_LABEL_X = $4C
MORE_CHANNELS_LABEL_Y = $08

;; Dynamic Locations
CURRENT_PATTERN_DISPLAY_X = $20
CURRENT_PATTERN_DISPLAY_Y = $02
CURRENT_ROW_DISPLAY_X = $28
CURRENT_ROW_DISPLAY_Y = $02
SPEED_DISPLAY_X = $20
SPEED_DISPLAY_Y = $01
NUMBER_OF_ORDERS_DISPLAY_X = $2B
NUMBER_OF_ORDERS_DISPLAY_Y = $01
CURRENT_ORDER_DISPLAY_X = $28
CURRENT_ORDER_DISPLAY_Y = $01

;; Colors
HEADER_BACKGROUND_COLOR = $B0
FRAME_COLOR = $B1
TITLE_COLORS = $BF
TEXT_COLORS = $BE
EDITABLE_TEXT_COLORS = $C1
PATTERN_ROW_NUMBER_COLOR = $01    ; Foreground Only
PATTERN_NOTE_COLOR = $01
PATTERN_INST_COLOR = $0F
PATTERN_VOL_COLOR = $0E
PATTERN_EFX_COLOR = $06
VERA_CHANNEL_COLOR = $B5
;;; Background
PATTERN_BACKGROUND_COLOR = $00  ; background only (top nibble)
MAJOR_HIGHLIGHT_COLOR = $C0     ; background only
MINOR_HIGHLIGHT_COLOR = $B0     ; background only
CURRENT_ROW_BACKGROUND_COLOR = $40 ; background only

; Scroll offset to send to VERA to start the pattern in the middle
; of the window. Here we are using a negative number.
PATTERN_SCROLL_START_H = $FF
PATTERN_SCROLL_START_L = $00

; Position the pattern so it's at the top of the pattern UI
; This is for when not scrolling, or when editing a pattern
STATIC_PATTERN_SCROLL_H = $FF
STATIC_PATTERN_SCROLL_L = $B0

;NUMBER_OF_CHANNELS = $01
;TOTAL_BYTES_PER_PATTERN = $0140    ; currently 5 * 64 rows
;TOTAL_BYTES_PER_ROW = $05         ; total bytes per row (for skipping rows)
;NUMBER_OF_CHANNELS = $02
;TOTAL_BYTES_PER_PATTERN = $0280    ; currently 5 bytes * 2 channels * 64 rows
;TOTAL_BYTES_PER_ROW = $0A         ; total bytes per row (for skipping rows)
;NUMBER_OF_CHANNELS = $03
;TOTAL_BYTES_PER_PATTERN = $03C0    ; currently 5 bytes * 3 channels * 64 rows
;TOTAL_BYTES_PER_ROW = $0F         ; total bytes per row (for skipping rows)

;NUMBER_OF_CHANNELS = $06
;TOTAL_BYTES_PER_PATTERN = $0780    ; currently 5 bytes * 6 channels * 64 rows
;TOTAL_BYTES_PER_ROW = $1E         ; total bytes per row (for skipping rows)

; 25 Channels (16 PSG, 8 FM, 1 DPCM)
NUMBER_OF_CHANNELS = $19
TOTAL_BYTES_PER_PATTERN = $1F40    ; currently 5 bytes * 25 channels * 64 rows
TOTAL_BYTES_PER_ROW = $7D         ; total bytes per row (for skipping rows), 5*25

TOTAL_BYTES_PER_CHANNEL = $05
NUM_VERA_PSG_REGISTERS = $04


; Temp Vars (these will come from the song file)
;SPEED = $40                ; how many vblanks to do nothing for
SPEED = $04                ; how many vblanks to do nothing for
;SPEED = $01
;SPEED = $0A                 ; how many vblanks to do nothing for
;SPEED = $30                ; how many vblanks to do nothing for

ROW_MAX = $40               ; Max # of rows for our test pattern (64)
ROW_MAJOR = $10             ; Every 16 rows
ROW_MINOR = $04             ; Every 4 rows


; Place to start the orders list
ORDER_LIST_X = $20
ORDER_LIST_Y = $0A
; How many characters over the patterns are
ORDER_LIST_OFFSET = $08
MAX_ORDERS = $FF

; Row statuses
NOTEREL  = $0D
NOTEOFF  = $0E
NOTENULL = $0F
VOLNULL  = $FF
INSTNULL = $FF
EFFNULL = $FF
NOTEOFF_FLAG = %10000000
NOTEREL_FLAG = %01000000
; This is when a new note is played. If so, we flag it so we know to use
; the instrument's default volume
NOTEPLAY_FLAG = %00010000

; How many values an Octave is
OCTAVE = $0C  ; 12

; Max allowable octave
MAX_OCTAVE = $09


; States
STOP_STATE = $00
PLAY_STATE = $01
