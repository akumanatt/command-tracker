; Draws the lower UI element for the help view
; Admittedly this is kinda hard coded at the moment.
.proc draw_help_frame

draw_help_frame:
  jsr ui::clear_lower_frame

@print_labels:
  print_string_macro help_text, #$05, #$0E, #TITLE_COLORS

@end:
  rts

help_text:
  .byte "f1  : help", $0D
  .byte "f2  : edit pattern", $0D
  .byte "f5  : play song", $0D
  .byte "f8  : stop", $0D
  ;.byte "f9  : load", $0D
  .byte "f10 : save", $0D
  .byte "f11 : orders", $0D
  .byte 0

.endproc
