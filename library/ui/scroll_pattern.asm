.proc scroll_pattern

; r15 = place to hold 16-bit shift value
scroll_pattern:
  ; Check if we want to scroll or not
  ; Currently we are not scrolling on playback (too expensive)
  ; Just when playing an isolated pattern
  lda SCROLL_ENABLE
  beq @end

  ; if we're on row 0, we need to set the scroll, otherwise we jump past it
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
  jsr ui::scroll_pattern_up

@end:
  rts

.endproc

.proc scroll_pattern_up
scroll_pattern_up:
  clc
  lda VERA_L0_vscroll_l
  adc #$08
  sta VERA_L0_vscroll_l
  lda VERA_L0_vscroll_h
  adc #$00
  sta VERA_L0_vscroll_h
  rts
.endproc

.proc scroll_pattern_down
scroll_pattern_down:
  sec
  lda VERA_L0_vscroll_l
  sbc #$08
  sta VERA_L0_vscroll_l
  lda VERA_L0_vscroll_h
  sbc #$00
  sta VERA_L0_vscroll_h
  rts
.endproc
