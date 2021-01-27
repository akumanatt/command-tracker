.proc print_speed
print_speed:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #SPEED_DISPLAY_X
  ldy #SPEED_DISPLAY_Y
  jsr vera_goto_xy

  ; Color
  set_text_color #$B1
  lda #SPEED       ; Get the current row conunt
  jsr printhex_vera        ; print it
  rts
.endproc
