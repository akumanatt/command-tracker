; Write a string of bytes
; r0 = string pointer
; r1 = length
.proc write_string
@write_string:
  ldy #$00
@write_loop:
  lda (order_list),y
  jsr CHROUT
  iny
  cpy r1
  bne @write_loop
.endproc
