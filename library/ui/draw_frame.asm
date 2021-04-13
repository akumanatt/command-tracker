.proc draw_frame
  DISPLAY_END_X = $4F
  DISPLAY_END_Y = $3B
draw_frame:
  ; color
  lda #FRAME_COLOR
  sta r0

  ;x/y start
  lda #$0
  sta r1
  sta r3
  ; x end
  lda #DISPLAY_END_X
  sta r2
  ; y end
  lda #DISPLAY_END_Y
  sta r4

  jsr graphics::drawing::draw_rounded_box
  lda #$00
  tax
  jsr graphics::drawing::goto_xy

@color_fill_frame:
  ; X/Y Start
  lda #$01
  sta r0
  sta r1
  ; X End
  ;lda #$4E
  ; For new emu/ROM, but this doesn't make any sense? It should be $4E....
  ;lda #$51
  lda #$4E
  sta r2
  ; Y End
  lda #$3A
  sta r3
  lda #HEADER_BACKGROUND_COLOR
  sta r4
  jsr graphics::drawing::draw_solid_box

@print_top_frame_titles:
  print_string_macro command_tracker_string, #PROGRAM_TITLE_X, #PROGRAM_TITLE_Y, #TITLE_COLORS
  print_string_macro song_label, #SONG_TITLE_LABEL_X, #SONG_TITLE_LABEL_Y, #TITLE_COLORS
  print_string_macro composer_label, #COMPOSER_LABEL_X, #COMPOSER_LABEL_Y, #TITLE_COLORS
  print_string_macro speed_label, #SPEED_LABEL_X, #SPEED_LABEL_Y, #TITLE_COLORS
  print_string_macro pattern_label, #PATTERN_LABEL_X, #PATTERN_LABEL_Y, #TITLE_COLORS
  print_string_macro order_label, #ORDER_LABEL_X, #ORDER_LABEL_Y, #TITLE_COLORS
  print_string_macro row_label, #ROW_LABEL_X, #ROW_LABEL_Y, #TITLE_COLORS
  print_string_macro instrument_label, #INSTRUMENT_LABEL_X, #INSTRUMENT_LABEL_Y, #TITLE_COLORS
  print_string_macro octave_label, #OCTAVE_LABEL_X, #OCTAVE_LABEL_Y, #TITLE_COLORS

  rts
.endproc
