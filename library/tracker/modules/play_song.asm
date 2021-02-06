play_song:
  sei

  ; Hard set scroll
  lda #$01
  sta SCROLL_ENABLE

  ; Check current state, if 0, don't remove ISR
  lda STATE
  beq start_song
  jsr disable_irq
start_song:
  lda #PLAY_STATE
  sta STATE
  ; First stuff before song starts to play
  ;jsr ui::draw_frame
  jsr ui::draw_pattern_frame
  jsr sound::stop_all_voices
  ldy #$00
  sty ORDER_NUMBER
  lda order_list,y
  sty ROW_COUNT
  sta RAM_BANK
  sta PATTERN_NUMBER
  jsr ui::print_song_info
  jsr ui::print_speed
  ;jsr ui::print_number_of_orders
  jsr ui::print_current_order
  jsr ui::print_current_pattern_number
  jsr ui::print_pattern

  ; Prepare for playback
  jsr sound::setup_voices
  jsr enable_irq

  cli
  jmp main_play_loop

; Loop on user interaction
main_play_loop:
  wai
check_keyboard:
  jsr GETIN  ;keyboard
  cmp #F1
  beq @help_module
  cmp #F8
  beq @stop_song
  cmp #F5
  beq @play_song_module
  cmp #F11
  beq @order_list_module
  jmp main_play_loop

@help_module:
  jmp main

@play_song_module:
  jmp tracker::modules::play_song

@stop_song:
  jsr tracker::stop_song
  jmp main_play_loop

@order_list_module:
  jmp tracker::modules::orders
