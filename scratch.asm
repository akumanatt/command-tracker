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
; 10 end of that channel (skip 2)

NOTE_COLUMN_POSITIION = $00
INSTRUMENT_COLUMN_POSITIION = $03
VOLUMNE_COLUMN_POSITIION = $05
EFFECT_COLUMN_POSITIION = $07
EFFECT_VALUE_COLUMN_POSITIION = $09
LAST_COLUMN_POSITION = $0A


; Vars
COLOR       = r0
PATTERN_ROW = r13
CHANNEL     = r14
COLUMN_POS  = r14 + 1      ; Note, Inst, Vol, Eff, Effect Value

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
  sta COLUMN_POS

edit_pattern_loop:
  wai
  jsr GETIN  ;keyboard
  cmp #KEY_UP
  beq @cursor_up
  cmp #KEY_DOWN
  beq @cursor_down
  cmp #KEY_LEFT
  beq @cursor_left
  cmp #KEY_RIGHT
  beq @cursor_right
  cmp #$30
  bpl @print_note_or_alphanumeric
  jmp edit_pattern_loop

@cursor_up:
  lda PATTERN_ROW
  beq edit_pattern_loop
  jsr ui::cursor_up
  dec PATTERN_ROW
  jmp edit_pattern_loop
@cursor_down:
  ;lda order_list_position
  ;cmp #$FF
  ;beq @main_orders_loop
  jsr ui::cursor_down
  inc PATTERN_ROW
  jmp edit_pattern_loop

@cursor_left:

  ;lda order_list_column
  ;cmp #ORDERS_MAX_COLUMN
  ;beq @main_orders_loop
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
  lda CHANNEL
  beq edit_pattern_loop
  jsr ui::cursor_left
  jsr ui::cursor_left
  lda #LAST_COLUMN_POSITION
  sta COLUMN_POS
  dec CHANNEL
  jmp edit_pattern_loop

@cursor_right:
  ;lda order_list_column
  ;cmp #ORDERS_MAX_COLUMN
  ;beq @main_orders_loop
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
  lda #$03
  sta COLUMN_POS
  jmp edit_pattern_loop

@cursor_right_channel:
  jsr ui::cursor_right
  jsr ui::cursor_right
  lda #$00
  sta COLUMN_POS
  inc CHANNEL
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
  cmp #PETSCII_G
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
  ;beq @save_order
  beq @print_end
  jsr ui::cursor_right
  inc COLUMN_POS
  jmp @print_end

@print_note:
  lda #$01
  sta COLOR
  lda #$11
  sta VERA_addr_high
  pla
  tax
  jsr graphics::drawing::print_alpha_char
  txa
  jsr graphics::drawing::print_alpha_char
  txa
  jsr graphics::drawing::print_alpha_char
  jsr ui::cursor_right
  jsr ui::cursor_right
  jsr ui::cursor_right
  lda #$03
  sta COLUMN_POS
  lda #$01
  sta VERA_addr_high

@print_end:
  jmp edit_pattern_loop


.include "data.inc"
