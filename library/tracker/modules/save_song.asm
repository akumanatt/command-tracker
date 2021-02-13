.proc save_song
  ; Constants
  CURSOR_START_X = $12
  CURSOR_START_Y = $0A



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
  ;cmp #F10
  ;beq @save_song
  cmp #F11
  beq @order_list_module
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
  jmp main_application_loop

@save_song:
  jmp tracker::modules::save_song

@order_list_module:
  jmp tracker::modules::orders

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
