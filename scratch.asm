; The main application which is responsible for calling different modules

.include "includes.inc"

; Constants
NOTE          = $00
INSTRUMENT    = $01
VOLULME       = $02
EFFECT        = $03
EFFECT_VALUE  = $04

; If col pos is 0, note
; If 3 inst
; If 5 vol
; 7 eff
; 9 eff val
; 10 end of that PATTERN_CHANNEL (skip 2)

NOTE_COLUMN_POSITIION = $00
INSTRUMENT_COLUMN_POSITIION = $03
VOLUMNE_COLUMN_POSITIION = $05
EFFECT_COLUMN_POSITIION = $07
EFFECT_VALUE_COLUMN_POSITIION = $09
LAST_COLUMN_POSITION = $0A

; Vars
COLOR           = r0
; Actual row # irrespective of screen scroll
PATTERN_ROW     = r1
; Screen row pos (may differ from pattern when scrolling)
SCREEN_ROW      = r1 + 1
; Actual Channel #
PATTERN_CHANNEL = r2        ; Actual channel
; Relative Channel position # (0-5) when tabbing over
SCREEN_CHANNEL  = r2 + 1
COLUMN_POS      = r3       ; Note, Inst, Vol, Eff, Effect Value

; Initial run once stuff
start:
  jsr setup
  jsr ui::draw_frame
  jsr ui::draw_pattern_frame
  jsr ui::print_pattern
  lda #$FF
  sta VERA_L0_hscroll_h
  lda #$F8
  sta VERA_L0_hscroll_l
  lda #STATIC_PATTERN_SCROLL_H
  sta VERA_L0_vscroll_h
  lda #STATIC_PATTERN_SCROLL_L
  sta VERA_L0_vscroll_l

main:
  ; We're editing the lower layer where the pattern is
  lda #$01
  sta cursor_layer
  lda #$03
  sta cursor_x
  lda #$00
  sta cursor_y
  jsr graphics::drawing::cursor_plot
  ;jsr ui::draw_help_frame

  lda #$00
  sta PATTERN_ROW
  sta PATTERN_CHANNEL
  sta SCREEN_ROW
  sta SCREEN_CHANNEL
  sta COLUMN_POS

edit_pattern_loop:
  wai
  jsr GETIN  ;keyboard
  cmp #$00
  beq edit_pattern_loop
  cmp #F1
  beq @help_module
  ;cmp #F2
  ;beq @edit_pattern_module
  cmp #F5
  beq @play_song_module
  cmp #F8
  beq @stop_song
  cmp #KEY_UP
  beq @cursor_up_jump
  cmp #KEY_DOWN
  beq @cursor_down_jump
  cmp #KEY_LEFT
  beq @cursor_left_jump
  cmp #KEY_RIGHT
  beq @cursor_right_jump
  cmp #PETSCII_BRACKET_LEFT
  beq @decrease_octave
  cmp #PETSCII_BRACKET_RIGHT
  beq @increase_octave
  cmp #$30
  bpl @print_note_or_alphanumeric_jump
  jmp edit_pattern_loop

@cursor_up_jump:
  jmp @cursor_up
@cursor_down_jump:
  jmp @cursor_down
@cursor_left_jump:
  jmp @cursor_left
@cursor_right_jump:
  jmp @cursor_right

@print_note_or_alphanumeric_jump:
  jmp @print_note_or_alphanumeric
@help_module:
  jmp main
@stop_song:
  jsr tracker::stop_song
  jmp edit_pattern_loop
@play_song_module:
  jmp tracker::modules::play_song

; Inc/Dec octave and update UI
@decrease_octave:
  lda user_octave
  beq @update_octave_end
  dec user_octave
  jmp @update_ui_octave
@increase_octave:
  lda user_octave
  cmp #MAX_OCTAVE
  beq @update_octave_end
  inc user_octave
  jmp @update_ui_octave
; TBD
@update_ui_octave:

@update_octave_end:
  jmp edit_pattern_loop


@cursor_up:
  lda PATTERN_ROW
  beq edit_pattern_loop
  jsr ui::cursor_up
  dec PATTERN_ROW
  dec SCREEN_ROW
  jmp edit_pattern_loop

@cursor_down:
  jsr ui::cursor_down
  inc PATTERN_ROW
  inc SCREEN_ROW
  jmp edit_pattern_loop

@cursor_left:
  lda COLUMN_POS
  beq @cursor_left_channel
  cmp #INSTRUMENT_COLUMN_POSITIION
  beq @cursor_left_note
  jsr ui::cursor_left
  dec COLUMN_POS
  jmp edit_pattern_loop
@cursor_left_note:
  jsr ui::cursor_left
  jsr ui::cursor_left
  jsr ui::cursor_left
  lda #$00
  sta COLUMN_POS
  jmp edit_pattern_loop
@cursor_left_channel:
  lda PATTERN_CHANNEL
  beq @cursor_left_end
  jsr ui::cursor_left
  jsr ui::cursor_left
  lda #LAST_COLUMN_POSITION
  sta COLUMN_POS
  dec PATTERN_CHANNEL
  dec SCREEN_CHANNEL
@cursor_left_end:
  jmp edit_pattern_loop

@cursor_right:
  lda COLUMN_POS
  beq @cursor_right_note
  cmp #LAST_COLUMN_POSITION
  beq @cursor_right_channel
  jsr ui::cursor_right
  inc COLUMN_POS
  jmp edit_pattern_loop
@cursor_right_note:
  jsr ui::cursor_right
  jsr ui::cursor_right
  jsr ui::cursor_right
  lda #INSTRUMENT_COLUMN_POSITIION
  sta COLUMN_POS
  jmp edit_pattern_loop
@cursor_right_channel:
  jsr ui::cursor_right
  jsr ui::cursor_right
  lda #$00
  sta COLUMN_POS
  inc PATTERN_CHANNEL
  inc SCREEN_CHANNEL
  jmp edit_pattern_loop

; If we're in the note column, print a note
; Otherwise print the hex-number the user typed
@print_note_or_alphanumeric:
  pha
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  lda COLUMN_POS
  beq @print_note
; Print the # the user typed.
@print_alphanumeric:
  pla
  cmp #PETSCII_AT
  bmi @print_numeric
  cmp #PETSCII_G  ; Do not print invalid chars
  bpl @print_end
@print_alpha:
  sbc #$3F  ; add 40 to get to the letter screencodes, then fall through
@print_numeric:
  sta VERA_data0
  inc VERA_addr_low
  lda #EDITABLE_TEXT_COLORS
  sta VERA_data0

  ; If we printed a character, and we're not at the last column
  ; move to the right
  lda COLUMN_POS
  cmp #LAST_COLUMN_POSITION
  beq @print_end
  jsr ui::cursor_right
  inc COLUMN_POS
  jmp @print_end

@print_note:
  lda #PATTERN_NOTE_COLOR
  sta COLOR
  lda #$11
  sta VERA_addr_high
  pla
  jsr @key_to_note

  lda #$01
  sta VERA_addr_high

  lda #PATTERN_INST_COLOR
  sta COLOR
  lda user_instrument
  jsr graphics::drawing::print_hex
  jsr @save_row_channel
  lda #$00
  sta COLUMN_POS
  jmp @cursor_down

@print_end:
  ;jsr @save_row_channel
  jmp edit_pattern_loop

@key_to_note:
  sbc #$2F      ; Subtract 30 as our LUT starts at '0'
  tay
  lda petscii_to_note,y
  jsr sound::decode_note
  lda NOTE_OCTAVE
  clc
  adc user_octave
  sta NOTE_OCTAVE
  jsr ui::print_note
  rts

; Write the current row we are on to the pattern
; This pulls the values from VRAM by figuring out
; which PATTERN_CHANNEL offset we are on, finding the beginning
; of that PATTERN_CHANNEL in VRAM, pulling the values, converting
; them and finally storing them back into the pattern data.
@save_row_channel:
  ; First find where we are on the screen
  lda SCREEN_CHANNEL
  jsr math::multiply_by_12
  clc
  adc #$03  ; For skipping past row numbers
  ldy SCREEN_ROW
  jsr graphics::drawing::goto_xy

  lda #$21
  sta VERA_addr_high

  ; Grab the values
  ; 3 bytes is the note, which we need to decode
  ;lda VERA_data0
  ;jsr graphics::kernal::printhex
  ;lda VERA_data0
  ;jsr graphics::kernal::printhex
  ;lda VERA_data0
  ;jsr graphics::drawing::print_hex
  ldx VERA_data0

  lda screencode_to_note,x
  ldy VERA_data0
  cpy #SCREENCODE_HASH
  bne @save_row_channel_not_sharp
  clc
  adc #$01
@save_row_channel_not_sharp:
  jsr graphics::kernal::printhex

  ; Now look at the absolute position within the pattern
  lda PATTERN_ROW
  ldy PATTERN_CHANNEL


  ; convert note

  ; convert inst
  ; convert vol
  ; convert eff #
  ; convert eff val

  ; update pattern
  lda #$01
  sta VERA_addr_high

  rts

.include "data.inc"
