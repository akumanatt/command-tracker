.proc update_row_count
update_row_count:
  ; Set stride to 1, high bit to 0
  lda #$10
  sta VERA_addr_high

  lda #CURRENT_ROW_X
  ldy #CURRENT_ROW_Y
  jsr vera_goto_xy

  ; Color
  lda #$B1
  sta r0
  lda ROW_COUNT       ; Get the current row conunt
  jsr printhex_vera        ; print it
  rts
.endproc
