.DATA

; The offset for the jump tables of the current module we are in
current_module: .byte $00

; Offset values are defined in variables.inc
init_jump_table_low:
  .byte <tracker::modules::help::init
  .byte <tracker::modules::psg_instruments::init
  .byte <tracker::modules::play_song_init
  .byte <tracker::modules::edit_pattern::init
  .byte <tracker::modules::save_song::init
  .byte <tracker::modules::orders::init
init_jump_table_high:
  .byte >tracker::modules::help::init
  .byte >tracker::modules::psg_instruments::init
  .byte >tracker::modules::play_song_init
  .byte >tracker::modules::edit_pattern::init
  .byte >tracker::modules::save_song::init
  .byte >tracker::modules::orders::init

loop_jump_table_low:
  .byte <tracker::modules::help::keyboard_loop
  .byte <tracker::modules::psg_instruments::keyboard_loop
  .byte <tracker::modules::play_song_keyboard_loop
  .byte <tracker::modules::edit_pattern::keyboard_loop
  .byte <tracker::modules::save_song::keyboard_loop
  .byte <tracker::modules::orders::keyboard_loop
loop_jump_table_high:
  .byte >tracker::modules::help::keyboard_loop
  .byte >tracker::modules::psg_instruments::keyboard_loop
  .byte >tracker::modules::play_song_keyboard_loop
  .byte >tracker::modules::edit_pattern::keyboard_loop
  .byte >tracker::modules::save_song::keyboard_loop
  .byte >tracker::modules::orders::keyboard_loop

; Order list is assumed to be up to 256 ($FF)
; we're manually loading it here, but reserving the rest
; so we don't run out of RAM while testing stuffs
;order_list: .byte $01, $02,$03,$04
;.res $FB
;order_list: .byte $09, $02,$05,$04, $01, $02, $03, $04, $05, $06, $08
;.res $F4

;order_list: .byte $02, $02, $01, $01
;.res $FB

;order_list: .byte $AB, $CD, $DE, $CD
;.res $FB

order_list: .byte $01
.res $FE

; An array to store the sorted order list - this is temporary data for when
; saving a song
order_list_sorted: .res $FF

; Where to start the order list display from
; (such as if we're scrolled further down)
order_list_start: .byte $00

; Where the cursor is in the order list
;order_list_position: .byte $00

; Which column the cursor is in (there are only 2 so 0/1)
order_list_column: .byte $00

; Key user pressed (we need to keep this across jump table calls)
key_pressed: .byte $00

; Current Octave User Has Specified
user_octave:   .byte $04
; User's current instrument
user_instrument: .byte $00




key: .byte $00
cursor_x: .byte $00
cursor_y: .byte $00
cursor_color: .byte $00
cursor_old_color: .byte $00
cursor_layer: .byte $00

; Note value to name lookup
note_names:  .byte "ccddeffggaab-^-."
note_sharps: .byte "-#-#--#-#-#--^-."

; Screencode to note number
; Note, if the actual note has a #, we add 1 to the value
screencode_to_note:
      ; NUL, A    B    C    D    E    F    G
  .byte $FF, $09, $0B, $00, $02, $04, $05, $07

; PETSCII to pattern note lookup
; Subtract $30 from PETSCII code
; Map the PETSCII values to the pattern storage format
; (oct, note #)
petscii_to_note:
  ; Numbers 0-9
      ; D#2, OFF, C#1, D#1, NOP, F#1, G#1, A#1, NOP, C#2
  .byte $23, $0E, $11, $13, $FF, $16, $18, $1A, $FF, $21
  ; Unused Keys (:, ;, ... 'a')
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  ; 'b' through 'l'
  ;     G-0, E-0, D#0, E-1, NOP, F#0, G#0, C-2, A#0, NOP, NOP
  .byte $07, $04, $03, $14, $FF, $06, $08, $20, $0A, $FF, $FF
  ; 'm' through 'w'
;       B-1, A-1, D-2, E-2, C-1, F-1, C#0, G-1, B-1, F-0, D-1
  .byte $1B, $19, $22, $24, $10, $15, $01, $17, $1B, $05, $12
  ; 'x-z, special chars, then left arrow
  ;     D-0, A-1, C-0, NOP, NOP, NOP, NOP, REL
  .byte $02, $19, $00, $FF, $FF, $FF, $FF, $0D

; 16 characters each
; We have the extra 0 at the end for the print macro
song_title:     .byte "                  ",0
composer:       .byte "                  ",0
;song_title:     .byte "bad apple         ",0
;composer:       .byte "m00dawg           ",0

; When we need to reference the OS filename which includes the
; @: to indicate file overwriting
full_filename:  .byte "@:"
filename:       .byte "                ",0
;filename:       .byte "song.cmt        ",0
;filename: .byte "song"

; Override the 16 color palette
; gb,r
palette:
.byte $02,$00     ; super dark blue
.byte $FF,$0F     ; white
.byte $00,$0F     ; red
.byte $4F,$04     ; cyan
.byte $04,$0A     ; purple
.byte $D0,$00     ; green
.byte $0F,$00     ; blue
.byte $F0,$0F     ; yellow
.byte $50,$0F     ; orange
.byte $30,$0A     ; brown
.byte $55,$0F     ; light red
.byte $22,$02     ; dark grey
.byte $44,$04     ; grey
.byte $F5,$05     ; light green
.byte $9F,$0A     ; light blue
.byte $88,$08     ; light gray

;.include "song.inc"
