.proc setup_voices
setup_voices:

  lda #%00000001
  sta VERA_ctrl

; This is to configure the base instrument - it's a placeholder
set_voice_1:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med
  lda #$C2
  sta VERA_addr_low
  lda #$FF
  sta VERA_data1
  lda #$C3
  sta VERA_addr_low
  lda #%01000000
  sta VERA_data1

set_voice_2:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med
  lda #$C6
  sta VERA_addr_low
  lda #$FF
  sta VERA_data1
  lda #$C7
  sta VERA_addr_low
  lda #%00010000
  sta VERA_data1

set_voice_3:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med
  lda #$CA
  sta VERA_addr_low
  lda #$FF
  sta VERA_data1
  lda #$CB
  sta VERA_addr_low
  lda #%11000000
  sta VERA_data1

  lda #%00000000
  sta VERA_ctrl
  rts
.endproc
