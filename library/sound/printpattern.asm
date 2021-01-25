.proc print_pattern
print_pattern:
  ; Set stride to 1, high bit to 1
  lda #$11
  sta VERA_addr_high
  ; row count
  ldy #$00

@loop:
  phy

  ; This is code that should be part of the scroll I think
  ; get row count, add it to the contant (offset on frame)
  ; tya
  ;clc
  ;adc #PATTERN_PLAY_POS
  ;tay   ; vera_goto_xy expects y-pos in y
  ;lda #$01  ; move over X
  ;jsr vera_goto_xy
  lda #$00  ; set x to 0
  jsr vera_goto_xy


  ; Print pattern
  ; color
  lda #PATTERN_ROW_NUMBER_COLOR
  sta r0
  ply
  tya
  jsr printhex_vera

  ; Move over one (for bar on top layer)
  lda $00
  sta r0
  jsr print_char_vera

  ; Print note
  lda pattern,y
  jsr decode_note
  set_text_color #PATTERN_ROW_NUMBER_COLOR
  jsr print_note

  ; Print vol
  ; placeholdr
  set_text_color #PATTERN_VOL_COLOR
  lda #$2E  ; .
  jsr print_char_vera
  lda #$2E  ; .
  jsr print_char_vera

  ; Print effect
  ; placeholdr
  set_text_color #PATTERN_EFX_COLOR
  lda #$2E  ; .
  jsr print_char_vera
  lda #$2E  ; .
  jsr print_char_vera
  lda #$2E  ; .
  jsr print_char_vera
  lda #$2E  ; .
  jsr print_char_vera


  iny
  cpy #ROW_MAX
  bne @loop
@end:
  rts
.endproc
