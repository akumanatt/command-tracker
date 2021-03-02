.proc draw_save_frame
  ; Constants
  SAVE_HEADER_X = $20
  SAVE_HEADER_Y = $08

  INPUT_TITLES_X = $05
  INPUT_TITLES_Y = $0A

  FILENAME_INPUT_X = $12
  FILENAME_INPUT_Y = $0D

  FILENAME_EXT_HEADER_X = $20
  FILENAME_EXT_HEADER_Y = $0D

  SONG_TITLE_INPUT_X = $12
  SONG_TITLE_INPUT_Y = $0A

  COMPOSER_INPUT_X = $12
  COMPOSER_INPUT_Y = $0B

  SPEED_INPUT_X = $12
  SPEED_INPUT_Y = $0C

  SAVE_ACCEPT_X = $12
  SAVE_ACCEPT_Y = $0E

start:
  print_string_macro save_header, #SAVE_HEADER_X, #SAVE_HEADER_Y, #TITLE_COLORS
  print_string_macro input_titles, #INPUT_TITLES_X, #INPUT_TITLES_Y, #TITLE_COLORS

  print_string_macro song_title, #SONG_TITLE_INPUT_X, #SONG_TITLE_INPUT_Y, #EDITABLE_TEXT_COLORS
  print_string_macro composer, #COMPOSER_INPUT_X, #COMPOSER_INPUT_Y, #EDITABLE_TEXT_COLORS
  print_string_macro filename, #FILENAME_INPUT_X, #FILENAME_INPUT_Y, #EDITABLE_TEXT_COLORS

  lda #SPEED_INPUT_X
  ldy #SPEED_INPUT_Y
  jsr graphics::drawing::goto_xy
  lda #EDITABLE_TEXT_COLORS
  sta r0
  lda SPEED
  jsr graphics::drawing::print_hex

  ;print_string_macro SPEED, #SPEED_INPUT_X, #SPEED_INPUT_Y, #EDITABLE_TEXT_COLORS


end:
  rts

save_header: .byte "load/save song",0
input_titles:
  .byte "title:", SCREENCODE_RETURN
  .byte "composer:", SCREENCODE_RETURN
  .byte "start speed:", SCREENCODE_RETURN
  .byte "filename:", SCREENCODE_RETURN
  .byte SCREENCODE_RETURN,SCREENCODE_RETURN,SCREENCODE_RETURN,SCREENCODE_RETURN
  .byte "cmd-s: save", SCREENCODE_RETURN
  .byte "cmd-l: load", SCREENCODE_RETURN
  .byte 0

.endproc
