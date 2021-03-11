.proc stop_song
stop_song:
  sei
  ; Check if we're already stopped
  lda STATE
  beq stopping_song
  jsr disable_irq
  jsr concerto_synth::deactivate_synth
stopping_song:
  ;jsr sound::stop_all_voices

  ; Reset scroll to beginning
  lda #PATTERN_SCROLL_START_H
  sta VERA_L0_vscroll_h
  lda #PATTERN_SCROLL_START_L
  sta VERA_L0_vscroll_l
  stz STATE

  cli
  rts

.endproc
