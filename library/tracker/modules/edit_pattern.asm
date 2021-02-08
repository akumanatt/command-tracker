; Edit pattern
.proc edit_pattern

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
; 10 end of that CHANNEL_NUMBER (skip 2)

NOTE_COLUMN_POSITIION = $00
INSTRUMENT_COLUMN_POSITIION = $03
VOLUMNE_COLUMN_POSITIION = $05
EFFECT_COLUMN_POSITIION = $07
EFFECT_VALUE_COLUMN_POSITIION = $09
LAST_COLUMN_POSITION = $0A

; Vars
COLOR           = r0
; Screen row pos (may differ from pattern when scrolling)
SCREEN_ROW      = r5
SCREEN_CHANNEL  = r5 + 1
COLUMN_POS      = r6       ; Note, Inst, Vol, Eff, Effect Value

; Initial run once stuff
edit_pattern:
  lda PATTERN_NUMBER
  sta RAM_BANK
  jsr ui::clear_lower_frame
  jsr ui::draw_pattern_frame
  jsr ui::print_pattern
  jsr ui::print_current_pattern_number
  lda #$FF
  sta VERA_L0_hscroll_h
  lda #$F8
  sta VERA_L0_hscroll_l
  lda #STATIC_PATTERN_SCROLL_H
  sta VERA_L0_vscroll_h
  lda #STATIC_PATTERN_SCROLL_L
  sta VERA_L0_vscroll_l

  ; We're editing the lower layer where the pattern is
  lda #$01
  sta cursor_layer
  lda #$03
  sta cursor_x
  lda #$00
  sta cursor_y
  jsr graphics::drawing::cursor_plot

  lda #$00
  sta ROW_NUMBER
  sta CHANNEL_NUMBER
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
  cmp #F11
  beq @order_list_module
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
  cmp #PETSCII_SHIFT_BACKSPACE
  beq @delete_channel_row_jump
  ;cmp #$30
  cmp #$2E    ; Alphanumeric, period, and a few things we don't want
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

@delete_channel_row_jump:
  jmp @delete_channel_row

@print_note_or_alphanumeric_jump:
  jmp @print_note_or_alphanumeric
@help_module:
  jmp main
@play_song_module:
  jmp tracker::modules::play_song
@order_list_module:
  jmp tracker::modules::orders

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
  lda ROW_NUMBER
  beq edit_pattern_loop
  jsr ui::cursor_up
  dec ROW_NUMBER
  dec SCREEN_ROW
  jmp edit_pattern_loop

@cursor_down:
  jsr ui::cursor_down
  inc  ROW_NUMBER
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
  lda CHANNEL_NUMBER
  beq @cursor_left_end
  jsr ui::cursor_left
  jsr ui::cursor_left
  lda #LAST_COLUMN_POSITION
  sta COLUMN_POS
  dec CHANNEL_NUMBER
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
  inc CHANNEL_NUMBER
  inc SCREEN_CHANNEL
  jmp edit_pattern_loop

; Delete the entire channel/row
@delete_channel_row:
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy

  ldx COLUMN_POS
  beq @print_periods
@goto_start_of_channel:
  jsr ui::cursor_left
  dex
  bne @goto_start_of_channel
@print_periods:
  stz COLUMN_POS
  ; Jump past colors
  lda #$21
  sta VERA_addr_high
  lda #SCREENCODE_PERIOD
  ldx #$0B  ; There's 11 dots in a pattern
@print_periods_loop:
  sta VERA_data0
  dex
  bne @print_periods_loop
  ; Disable stride
  lda #$01
  sta VERA_addr_high
  jsr @save_row_channel
  jmp @cursor_down


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
  jsr @save_row_channel
  jmp edit_pattern_loop

@key_to_note:
  sbc #$2F      ; Subtract to offset the values for the LUT
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
; which CHANNEL_NUMBER offset we are on, finding the beginning
; of that CHANNEL_NUMBER in VRAM, pulling the values, converting
; them and finally storing them back into the pattern data.
@save_row_channel:
  ; First, figure out where we are in the pattern
  lda ROW_NUMBER
  jsr tracker::get_row
  lda #$00
  ldx CHANNEL_NUMBER
  beq @store_channel
@channel_skip_loop:
  clc
  adc #TOTAL_BYTES_PER_CHANNEL
  dex
  bne @channel_skip_loop
@store_channel:
  ; This is our channel offset
  ; We'll put it into Y down below
  pha

  ; Then find where we are on the screen
  lda SCREEN_CHANNEL
  jsr math::multiply_by_12
  clc
  adc #$03  ; For skipping past row numbers
  ldy SCREEN_ROW
  jsr graphics::drawing::goto_xy

  ; Skip over colors
  lda #$21
  sta VERA_addr_high

  ldx VERA_data0
  lda screencode_to_note,x
  ldy VERA_data0
  ; If there is a #, add one as it is a sharp
  cpy #SCREENCODE_HASH
  bne @not_sharp
  ; sharp, so add 1 to value
  clc
  adc #$01
  sta NOTE_NOTE
@not_sharp:
  ; Now add the pitch
  lda VERA_data0
  ; We can grab the numbers from the lower nibble and just ignore
  ; the top
  asl
  asl
  asl
  asl
  ora NOTE_NOTE

  ; This was our channel offset from above
  ply
  sta (ROW_POINTER),y

  ; The next values are all 2-digit hex values
  ; so we can just do the same thing over and over

  ; Loop for instrument, volume, effect, and effect value
  ldx #$04
@store_rest_of_row_loop:
  lda VERA_data0
  cmp #SCREENCODE_PERIOD
  beq @store_null
  sta r0

  lda VERA_data0
  cmp #SCREENCODE_PERIOD
  beq @store_null
  sta r1
  jsr graphics::drawing::chars_to_number
  jmp @inc_row_pointer

@store_null:
  lda #EFFNULL

@inc_row_pointer:
  ; Inc our row pointer
  iny
  sta (ROW_POINTER),y
  dex
  bne @store_rest_of_row_loop
  lda #$01
  sta VERA_addr_high
  rts


.endproc
