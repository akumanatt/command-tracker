.scope save_song

; Constants
CURSOR_START_X = $12
CURSOR_START_Y = $0A
CURSOR_STOP_Y = $0D

SONG_TITLE_INPUT_X = $12
SONG_TITLE_INPUT_Y = $0A

COMPOSER_INPUT_X = $12
COMPOSER_INPUT_Y = $0B

SPEED_INPUT_X = $12
SPEED_INPUT_Y = $0C

FILENAME_INPUT_X = $12
FILENAME_INPUT_Y = $0D

.proc init
init:
  lda #SAVE_MODULE
  sta current_module
  lda #$20
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1
  jsr ui::clear_lower_frame
  jsr ui::draw_save_frame
  stz key_pressed

@cursor_start_position:
  lda #$00
  sta cursor_layer

  lda #CURSOR_START_X
  sta cursor_x
  lda #CURSOR_START_Y
  sta cursor_y
  jsr graphics::drawing::cursor_plot
.endproc

.proc keyboard_loop
@keyboard_loop:
  lda key_pressed
  cmp #COMMAND_S
  beq @save_song_jump
  cmp #COMMAND_L
  beq @load_song_jump
  cmp #KEY_UP
  beq @cursor_up_jump
  cmp #KEY_DOWN
  beq @cursor_down_jump
  cmp #KEY_LEFT
  beq @cursor_left_jump
  cmp #KEY_RIGHT
  beq @cursor_right_jump
  cmp #SPACE
  beq @cursor_right_jump
  cmp #PETSCII_BACKSPACE
  beq @backspace
  ; Start at period
  cmp #PETSCII_PERIOD
  bpl @print_letters
  jmp main_application_loop

@save_song_jump:
  jmp @save_song

@load_song_jump:
  jmp @load_song

@cursor_up_jump:
  jmp @cursor_up
@cursor_down_jump:
  jmp @cursor_down
@cursor_left_jump:
  jmp @cursor_left
@cursor_right_jump:
  jmp @cursor_right

@print_letters:
  pha
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  ldx #EDITABLE_TEXT_COLORS
  stx r0
  pla
  jsr graphics::drawing::print_alpha_char
  jsr ui::cursor_right
  jsr @update_info
@print_end:
  jmp main_application_loop

@backspace:
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  lda #SCREENCODE_BLANK
  sta VERA_data0
  ; If we're at the beginning, don't move left
  lda cursor_x
  cmp #CURSOR_START_X
  beq @backspace_end
  jsr ui::cursor_left
@backspace_end:
  jmp main_application_loop

@cursor_up:
  lda cursor_y
  cmp #CURSOR_START_Y
  beq @cursor_up_end
  lda #CURSOR_START_X
  sta cursor_x
  dec cursor_y
  jsr graphics::drawing::cursor_plot
  ;jsr @update_info
@cursor_up_end:
  jmp main_application_loop

@cursor_down:
  lda cursor_y
  cmp #CURSOR_STOP_Y
  beq @cursor_down_end
  jsr graphics::drawing::cursor_unplot
  lda #CURSOR_START_X
  sta cursor_x
  inc cursor_y
  jsr graphics::drawing::cursor_plot
  ;jsr @update_info
@cursor_down_end:
  jmp main_application_loop

@cursor_left:
  lda cursor_x
  cmp #CURSOR_START_X
  beq @cursor_left_end
  jsr ui::cursor_left
@cursor_left_end:
  jmp main_application_loop

@cursor_right:
  jsr ui::cursor_right
  inc order_list_column
@cursor_right_end:
  jmp main_application_loop

@order_list_module:
  ;jmp tracker::modules::orders

; Update title, composer, speed, and filename
@update_info:
  sei
  ; Skip over colors
  lda #$20
  sta VERA_addr_high
@update_song_title:
  lda #SONG_TITLE_INPUT_X
  ldy #SONG_TITLE_INPUT_Y
  jsr graphics::drawing::goto_xy
  ldx #SONG_TITLE_MAX_LENGTH
  ldy #$00
@update_song_title_loop:
  lda VERA_data0
  sta song_title,y
  iny
  dex
  bne @update_song_title_loop

@update_composer:
  lda #COMPOSER_INPUT_X
  ldy #COMPOSER_INPUT_Y
  jsr graphics::drawing::goto_xy
  ldx #COMPOSER_MAX_LENGTH
  ldy #$00
@update_composer_loop:
  lda VERA_data0
  sta composer,y
  iny
  dex
  bne @update_composer_loop

@update_speed:
  lda #SPEED_INPUT_X
  ldy #SPEED_INPUT_Y
  jsr graphics::drawing::goto_xy
  lda VERA_data0
  sta r0
  lda VERA_data0
  sta r1
  jsr graphics::drawing::chars_to_number
  sta SPEED

@update_filename:
  lda #FILENAME_INPUT_X
  ldy #FILENAME_INPUT_Y
  jsr graphics::drawing::goto_xy
  ldx #FILENAME_MAX_LENGTH
  ldy #$00
; Screencode to PETSCII conversion logic happening here
@update_filename_loop:
  lda VERA_data0
  cmp #SCREENCODE_BLANK
  beq @update_end
  cmp #PETSCII_PERIOD
  bcs @update_char
  clc
  adc #$40
@update_char:
  sta filename,y
  iny
  dex
  bne @update_filename_loop

@update_end:
  ;jsr ui::draw_frame
  jsr ui::print_song_info
  jsr ui::print_speed
  ;jsr ui::draw_save_frame
  cli
  rts


@load_song:
  print_string_macro load_text, #$05, #$0F, #TITLE_COLORS
  jsr tracker::load_song
  print_string_macro done_text, #$0E, #$0F, #TITLE_COLORS
  jsr ui::print_song_info
  jsr ui::print_speed
  jsr ui::draw_save_frame
  jmp main_application_loop

; Save song
@save_song:
  print_string_macro save_text, #$05, #$0F, #TITLE_COLORS
  jsr tracker::save_song
  print_string_macro done_text, #$0E, #$0F, #TITLE_COLORS
  jmp main_application_loop


; Strings
save_text: .byte "saving...     ", 0
load_text: .byte "loading..     ", 0
done_text: .byte "done!",0

.endproc

.endscope
