; Draws the lower UI element for the orders view
.proc draw_orders_frame
  ; Constants
  ORDERS_HEADER_X = $20
  ORDERS_HEADER_Y = $08

draw_orders_frame:
  ; X/Y Start
  lda #$01
  sta r0
  lda #$06
  sta r1
  ; X End
  lda #$4E
  sta r2
  ; Y End
  lda #$35
  sta r3
  lda #HEADER_BACKGROUND_COLOR
  sta r4
  jsr graphics::drawing::draw_solid_box

@print_labels:
  print_string_macro order_list_label, #ORDERS_HEADER_X, #ORDERS_HEADER_Y, #TITLE_COLORS
  print_string_macro order_screen_help_msg, #$18, #$36, #TITLE_COLORS

@list_orders:
  lda #ORDER_LIST_X
  ldy #ORDER_LIST_Y
  jsr graphics::drawing::goto_xy
  ldx order_list_start
@list_orders_loop:
  lda #ORDER_LIST_X
  jsr graphics::drawing::goto_xy
  lda #TITLE_COLORS
  sta r0
  txa
  jsr graphics::drawing::print_hex

  print_char_with_color #COLON, #TITLE_COLORS
  print_char_with_color #SPACE, #TITLE_COLORS
  ; Do this up to the song's current orders
  cpx order_list_length
  bpl @done_with_user_orders
  lda order_list,x
  pha
  lda #EDITABLE_TEXT_COLORS
  sta r0
  pla
  jsr graphics::drawing::print_hex
  jmp @end_loop

; Done with real orders, so add dashes to the rest of the list
@done_with_user_orders:
  print_char_with_color #PETSCII_DASH, #EDITABLE_TEXT_COLORS
  print_char_with_color #PETSCII_DASH, #EDITABLE_TEXT_COLORS
@end_loop:
  inx
  iny
  cpy #NUM_ORDERS_TO_SHOW
  bne @list_orders_loop

;order_list_length: .byte $03
;order_list: .byte $01,02,$03,$04

@end:
  rts
.endproc
