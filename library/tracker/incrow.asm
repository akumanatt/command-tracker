.proc inc_row

inc_row:
  lda ROW_COUNT       ; get it again (printhex blows it away)
  clc
  adc #1              ; increment row count
  sta ROW_COUNT       ; store it

  cmp #ROW_MAX        ; see if we're at the row max
  beq @row_max      ; if not, jump to end; if so, go to row_max
  rts
@row_max:
  lda 0
  sta ROW_COUNT
return:
  rts

.endproc