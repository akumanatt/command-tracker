.proc save_song
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

start:
  lda #$10
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1
  jsr ui::clear_lower_frame
  jsr ui::draw_save_frame

@cursor_start_position:
  lda #$00
  sta cursor_layer

  lda #CURSOR_START_X
  sta cursor_x
  lda #CURSOR_START_Y
  sta cursor_y
  jsr graphics::drawing::cursor_plot


@main_save_loop:
  wai
@check_keyboard:
  ; Returns 0 is no input
  jsr GETIN  ;keyboard
  cmp #F1
  beq @help_module
  cmp #F2
  beq @edit_pattern_module
  cmp #F5
  beq @play_song_module
  cmp #F8
  beq @stop_song
  cmp #COMMAND_S
  beq @save_song_jump
  cmp #COMMAND_L
  beq @load_song_jump
  cmp #F11
  beq @order_list_module_jump
  cmp #KEY_UP
  beq @cursor_up
  cmp #KEY_DOWN
  beq @cursor_down
  cmp #PETSCII_BACKSPACE
  beq @backspace
  ; Start at period
  cmp #$2E
  bpl @print_letters

  jmp @main_save_loop

@help_module:
  jmp main

@order_list_module_jump:
  jmp @order_list_module

@save_song_jump:
  jmp @save_song

@load_song_jump:
  jmp @load_song

@edit_pattern_module:
  jsr tracker::stop_song
  jmp tracker::modules::edit_pattern

@play_song_module:
  jmp tracker::modules::play_song

@stop_song:
  jsr tracker::stop_song
  jmp @main_save_loop

@cursor_up:
  lda cursor_y
  cmp #CURSOR_START_Y
  beq @cursor_up_end
  jsr @update_info
  jsr ui::cursor_up
@cursor_up_end:
  jmp @main_save_loop

@cursor_down:
  lda cursor_y
  cmp #CURSOR_STOP_Y
  beq @cursor_down_end
  jsr @update_info
  jsr ui::cursor_down
@cursor_down_end:
  jmp @main_save_loop

@order_list_module:
  jmp tracker::modules::orders

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
  jmp @main_save_loop

@print_letters:
  pha
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  pla
  ldx #EDITABLE_TEXT_COLORS
  stx r0
  jsr graphics::drawing::print_alpha_char
  jsr ui::cursor_right
@print_end:
  jmp @main_save_loop


; Update title, composer, speed, and filename
@update_info:
  ; Skip over colors
  lda #$20
  sta VERA_addr_high
@update_song_title:
  lda #SONG_TITLE_INPUT_X
  ldy #SONG_TITLE_INPUT_Y
  jsr graphics::drawing::goto_xy
  ldx #SONG_TITLE_MAX_LENGTH
  ldy #$0
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
  ldy #$0
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

@update_end:
  ;jsr ui::draw_frame
  jsr ui::print_song_info
  jsr ui::print_speed
  ;jsr ui::draw_save_frame
  rts


@load_song:
  print_string_macro load_text, #$05, #$0F, #TITLE_COLORS
  print_string_macro done_text, #$0E, #$0F, #TITLE_COLORS
  jmp @main_save_loop

; Save song
@save_song:
  print_string_macro save_text, #$05, #$0F, #TITLE_COLORS
  jsr tracker::save_song
  print_string_macro done_text, #$0E, #$0F, #TITLE_COLORS
  jmp @main_save_loop


; Strings
save_text: .byte "saving...     ", 0
load_text: .byte "loading..     ", 0
done_text: .byte "done!",0

.endproc
