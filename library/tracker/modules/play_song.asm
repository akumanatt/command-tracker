.proc play_song_init
play_song_init:
  sei

  jsr tracker::stop_song
  ; Check current state, if 0, don't remove ISR
  lda STATE
  beq start_song
  stz key_pressed
  ;jsr disable_irq
  ;jsr concerto_synth::deactivate_synth

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
  ;jsr concerto_synth::activate_synth
  jsr play_irq
  cli
.endproc

.proc play_song_keyboard_loop
; Loop on user interaction
play_song_keyboard_loop:
  jmp main_application_loop
.endproc
