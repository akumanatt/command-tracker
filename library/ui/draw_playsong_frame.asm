; Draws the lower UI element for the pattern view

.proc draw_playsong_frame

draw_playsong_frame:
  jsr ui::clear_lower_frame

@print_labels:
  print_string_macro play_text, #$05, #$0E, #TITLE_COLORS

@end:
  rts

play_text:
  .byte "playing song...", SCREENCODE_RETURN
  .byte "placeholder for future graphics", SCREENCODE_RETURN
  .byte 0

.endproc
