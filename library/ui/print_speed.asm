.proc print_speed
print_speed:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #SPEED_DISPLAY_X
  ldy #SPEED_DISPLAY_Y
  jsr graphics::drawing::goto_xy

  ; Color
  set_text_color #TEXT_COLORS
  lda SPEED       ; Get the current row conunt
  jsr graphics::drawing::print_hex
  rts
.endproc
