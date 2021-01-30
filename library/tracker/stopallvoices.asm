.proc stop_all_voices
stop_all_voices:
  ldx #$C0
@loop:
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med

  stx VERA_addr_low
  lda #$00
  sta VERA_data0

  inx
  ; Why Zero? We want to get to #$FF so we're rolling over on purpose
  cpx #$00
  bne @loop
  rts

.endproc
