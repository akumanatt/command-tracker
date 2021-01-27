.proc print_row_count
print_row_count:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #CURRENT_ROW_DISPLAY_X
  ldy #CURRENT_ROW_DISPLAY_Y
  jsr vera_goto_xy

  ; Color
  set_text_color #$B1
  lda ROW_COUNT       ; Get the current row conunt
  jsr printhex_vera        ; print it
  rts
.endproc
