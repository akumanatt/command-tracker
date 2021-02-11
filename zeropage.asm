.ZEROPAGE

; Zero Page Addresses
; Reserved by X16 Kernel
RESERVED: .res $22

VBLANK_SKIP_COUNT: .byte 0   ; Count of current VBLANK skip
NOTE_NOTE: .byte 0
NOTE_OCTAVE: .byte 0
NOTE_NUMERIC: .byte 0
PATTERN_NUMBER: .byte 0
ROW_NUMBER: .byte 0
CHANNEL_NUMBER: .byte 0
ORDER_NUMBER: .byte 0
SCROLL_ENABLE: .byte 0

; Channel to start when displaying the pattern on screen
START_CHANNEL: .byte 0

; Track the state of the tracker engine
; 0 = Stopped
; 1 = Playing
STATE: .byte 0

ROW_POINTER: .word $0000           ; 16-bit address of the row in the pattern
STRING_POINTER: .word $0000
PREVIOUS_ISR_HANDLER: .word $0000
