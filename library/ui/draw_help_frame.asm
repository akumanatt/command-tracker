; Draws the lower UI element for the help view
; Admittedly this is kinda hard coded at the moment.
.proc draw_help_frame

draw_help_frame:
  lda #$10
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1
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
  print_string_macro help_fkey, #$05, #$0A, #TITLE_COLORS
  print_string_macro play_fkey, #$05, #$0B, #TITLE_COLORS
  print_string_macro stop_fkey, #$05, #$0C, #TITLE_COLORS
  print_string_macro order_fkey, #$05, #$0D, #TITLE_COLORS

@end:
  rts

help_fkey:  .byte "f1 : help",0
play_fkey:  .byte "f5 : play song",0
stop_fkey:  .byte "f8 : stop song",0
order_fkey: .byte "f11: orders list",0

.endproc
