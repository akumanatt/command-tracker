.proc print_row_number
print_row_number:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #CURRENT_ROW_DISPLAY_X
  ldy #CURRENT_ROW_DISPLAY_Y
  jsr graphics::drawing::goto_xy

  ; Color
  set_text_color #TEXT_COLORS
  lda ROW_NUMBER       ; Get the current row conunt
  jsr graphics::drawing::print_hex
  rts
.endproc
