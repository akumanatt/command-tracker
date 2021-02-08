.proc print_current_pattern_number
print_current_pattern_number:
  ; Placeholder to display pattern (currently hardcoded to 01)
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high
  lda #CURRENT_PATTERN_DISPLAY_X
  ldy #CURRENT_PATTERN_DISPLAY_Y
  jsr graphics::drawing::goto_xy
  ; Color
  set_text_color #$B1
  lda PATTERN_NUMBER       ; Get the current pattern
  jsr graphics::drawing::print_hex        ; print it
  rts
.endproc
