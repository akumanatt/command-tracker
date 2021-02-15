.proc get_row
  SKIP_BYTES  = r11   ; return from add16
  ; ADD_TEMP  = r12

get_row:
  ; take the row count, add the number of bytes per row to get the
  ; next row
  lda ROW_NUMBER
  jsr @reset_pointer
  sta r0
  lda #TOTAL_BYTES_PER_ROW
  sta r1
  jsr math::multiply16
  sta SKIP_BYTES
  tya
  sta SKIP_BYTES+1

  ; this can be optimized to be in line with the above but for now...
  ; add SKIP_BYTES to ROW_POINTER (both 16-bit numbers)
  lda SKIP_BYTES
  sta r0
  lda SKIP_BYTES+1
  sta r0+1
  lda ROW_POINTER
  sta r1
  lda ROW_POINTER+1
  sta r1+1
  jsr math::add16
  lda r2
  sta ROW_POINTER
  lda r2+1
  sta ROW_POINTER+1
  ;lda ROW_POINTER+1
  ;jsr graphics::kernal::printhex
  ;lda ROW_POINTER
  ;jsr graphics::kernal::printhex
  ;tax;
  ;lda ROW_POINTER
  ;adc SKIP_BYTES
  ;sta ROW_POINTER
  ;lda ROW_POINTER+1
  ;adc #$00
  ;sta ROW_POINTER+1

@end:
  rts

@reset_pointer:
  pha
  lda #<PATTERN_ADDRESS
  sta ROW_POINTER
  lda #>PATTERN_ADDRESS
  sta ROW_POINTER+1
  pla
  rts

.endproc
