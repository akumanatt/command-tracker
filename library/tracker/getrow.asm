.proc get_row
  SKIP_BYTES  = r11   ; return from add16
get_row:
  ; take the row count, add the number of bytes per row to get the
  ; next row
  lda ROW_COUNT
  jsr @reset_pointer
  ; THIS WILL LIKELY ROLLOVER WITH EFFECTS! (5 bytes total)
  asl                 ; rows are 2 bytes now

  ; jsr printhex
  ;adc #TOTAL_BYTES_PER_ROW
  sta SKIP_BYTES
  clc
  tax
  lda ROW_POINTER
  adc SKIP_BYTES

  sta ROW_POINTER
  lda ROW_POINTER+1
  adc #$00
  sta ROW_POINTER+1

@end:
  rts

@reset_pointer:
  pha
  lda PATTERN_POINTER
  sta ROW_POINTER
  lda PATTERN_POINTER+1
  sta ROW_POINTER+1
  pla
  rts

.endproc
