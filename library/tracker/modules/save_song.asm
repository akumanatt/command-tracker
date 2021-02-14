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
  ;cmp #F10PETSCII_BACKSPACE
  ;beq @save_song
  cmp #F11
  beq @order_list_module
  cmp #KEY_UP
  beq @cursor_up
  cmp #KEY_DOWN
  beq @cursor_down
  cmp #PETSCII_BACKSPACE
  beq @backspace
  cmp #PETSCII_RETURN
  beq @save_song
  cmp #$30
  bpl @print_letters

  jmp @main_save_loop

@help_module:
  jmp main

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
  jsr ui::cursor_up
@cursor_up_end:
  jmp @main_save_loop

@cursor_down:
  lda cursor_y
  cmp #CURSOR_STOP_Y
  beq @cursor_down_end
  jsr ui::cursor_down
@cursor_down_end:
  jmp @main_save_loop

@save_song:
  ; Only save the song if we're on the filename row
  lda cursor_y
  cmp #FILENAME_INPUT_Y
  bne @save_song_end
  jsr tracker::save_song
@save_song_end:
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

.endproc
