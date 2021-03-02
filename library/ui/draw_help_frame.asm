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
  .byte "f1  : help", SCREENCODE_RETURN
  .byte "f2  : edit pattern", SCREENCODE_RETURN
  .byte "f5  : play song", SCREENCODE_RETURN
  .byte "f8  : stop", SCREENCODE_RETURN
  .byte "f10 : load/save", SCREENCODE_RETURN
  .byte "f11 : orders", SCREENCODE_RETURN
  .byte 0

.endproc
