.proc print_current_order
print_current_order:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #CURRENT_ORDER_DISPLAY_X
  ldy #CURRENT_ORDER_DISPLAY_Y
  jsr graphics::drawing::goto_xy

  ; Color
  set_text_color #$B1
  lda ORDER_NUMBER       ; Get the current row conunt
  jsr graphics::drawing::print_hex
  rts
.endproc
