.proc inc_row

inc_row:
  ldx  ROW_NUMBER       ; get it again (printhex blows it away)
  inx
  stx  ROW_NUMBER       ; store it

  cpx #ROW_MAX        ; see if we're at the row max
  beq @row_max      ; if not, jump to end; if so, go to row_max
  rts
@row_max:
  lda 0
  sta  ROW_NUMBER
return:
  rts

.endproc
