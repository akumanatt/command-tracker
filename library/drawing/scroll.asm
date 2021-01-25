.proc scroll
; r11 = place to hold 16-bit shift value
scroll:
  lda ROW_COUNT
  sta r15
  asl r15
  rol r15+1
  asl r15
  rol r15+1
  asl r15
  rol r15+1
  asl r15
  rol r15+1
  lda r15
  sta VERA_L0_vscroll_l
  lda r15+1
  sta VERA_L0_vscroll_h
.endproc
