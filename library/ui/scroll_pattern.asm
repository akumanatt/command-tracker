.proc scroll_pattern

; r15 = place to hold 16-bit shift value
scroll_pattern:
  lda SCROLL_ENABLE
  beq @end

  ; if we're on row 0, we need to set the scroll, other we jump past it
  lda ROW_NUMBER
  bne @scrolling

@initial_scroll:
  ; move pattern over by 1 character (so it fits in the frame)
  ; move pattern down by pattern_play_pos
  ; THIS SHOULD NOT BE HERE
  ; we shuld do this when playback of the song starts
  ; so we only call this once.
  lda #$FF
  sta VERA_L0_hscroll_h
  lda #$F8
  sta VERA_L0_hscroll_l

  ; This rolls the scroll backwards
  ; (FF00 = -256)
  ;lda #$EE
  lda #PATTERN_SCROLL_START_H
  sta VERA_L0_vscroll_h
  lda #PATTERN_SCROLL_START_L
  sta VERA_L0_vscroll_l
  rts

@scrolling:
  ; Add 8 to scroll
  clc
  lda VERA_L0_vscroll_l
  adc #$08
  sta VERA_L0_vscroll_l
  lda VERA_L0_vscroll_h
  adc #$00
  sta VERA_L0_vscroll_h

@end:
  rts


.endproc
