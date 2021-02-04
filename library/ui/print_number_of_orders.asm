.proc print_number_of_orders
print_number_of_orders:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #NUMBER_OF_ORDERS_DISPLAY_X
  ldy #NUMBER_OF_ORDERS_DISPLAY_Y
  jsr graphics::drawing::goto_xy

  ; Color
  set_text_color #$B1
  ; Removed order length for now so this doesn't matter
  ; lda order_list_length       ; Get the current row conunt
  lda #$FF
  jsr graphics::drawing::print_hex
  rts
.endproc
