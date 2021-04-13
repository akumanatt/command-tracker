.proc print_current_octave
print_current_octave:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high
  lda #OCTAVE_DISPLAY_X
  ldy #OCTAVE_DISPLAY_Y
  jsr graphics::drawing::goto_xy
  ; Color
  set_text_color #TEXT_COLORS
  lda user_octave       ; Get the current pattern
  jsr graphics::drawing::print_hex        ; print it
  rts
.endproc
