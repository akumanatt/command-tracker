play_song:
  sei

  ; Hard set scroll
  lda #$01
  sta SCROLL_ENABLE

  ; Check current state, if 0, don't remove ISR
  lda STATE
  beq start_song
  jsr disable_irq

  jsr concerto_synth::deactivate_synth
start_song:
  lda #PLAY_SONG_STATE
  sta STATE
  ; First stuff before song starts to play
  ;jsr ui::draw_frame
  ;jsr ui::draw_pattern_frame
  jsr ui::draw_playsong_frame
  jsr sound::stop_all_voices
  stz ORDER_NUMBER
  stz ROW_NUMBER
  ldy #$00
  lda order_list,y
  sta RAM_BANK
  sta PATTERN_NUMBER
  jsr ui::print_song_info
  jsr ui::print_speed
  ;jsr ui::print_number_of_orders
  jsr ui::print_current_order
  jsr ui::print_current_pattern_number
  jsr ui::print_pattern

  ; Prepare for playback
  ;jsr sound::setup_voices
  jsr concerto_synth::activate_synth
  jsr play_irq


  cli
  jmp main_play_loop

; Loop on user interaction
main_play_loop:
  wai
check_keyboard:
  jsr GETIN  ;keyboard
  cmp #F1
  beq @help_module
  cmp #F2
  beq @edit_pattern_module
  cmp #F8
  beq @stop_song
  cmp #F5
  beq @play_song_module
  cmp #F11
  beq @order_list_module
  jmp main_play_loop

@help_module:
  jmp main

; Jump to order list module
@edit_pattern_module:
  jsr tracker::stop_song
  jmp tracker::modules::edit_pattern

@play_song_module:
  jmp tracker::modules::play_song

@stop_song:
  jsr tracker::stop_song
  jmp main_play_loop

@order_list_module:
  jmp tracker::modules::orders
