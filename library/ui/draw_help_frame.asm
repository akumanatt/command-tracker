; Draws the lower UI element for the help view
; Admittedly this is kinda hard coded at the moment.
.proc draw_help_frame

draw_help_frame:
  jsr ui::clear_lower_frame

@print_labels:
  print_string_macro help_fkey, #$05, #$0A, #TITLE_COLORS
  print_string_macro edit_pattern_fkey, #$05, #$0B, #TITLE_COLORS
  print_string_macro play_fkey, #$05, #$0C, #TITLE_COLORS
  print_string_macro stop_fkey, #$05, #$0D, #TITLE_COLORS
  print_string_macro order_fkey, #$05, #$0E, #TITLE_COLORS

@end:
  rts

help_fkey:          .byte "f1 : help",0
edit_pattern_fkey:  .byte "f2 : edit pattern",0
play_fkey:          .byte "f5 : play song",0
stop_fkey:          .byte "f8 : stop song",0
order_fkey:         .byte "f11: orders list",0

.endproc
