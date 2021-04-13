.proc print_current_instrument
print_current_instrument:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high
  lda #INSTRUMENT_DISPLAY_X
  ldy #INSTRUMENT_DISPLAY_Y
  jsr graphics::drawing::goto_xy
  ; Color
  set_text_color #TEXT_COLORS
  lda user_instrument       ; Get the current pattern
  jsr graphics::drawing::print_hex        ; print it
  rts
.endproc
