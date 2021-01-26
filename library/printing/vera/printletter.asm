; Print letter to VERA (which requires simple math)
.proc print_letter_vera
  COLOR = r0
print_letter_vera:
  pha
  sec                   ; Converting from PETSCII to Screen Codes
  sbc #$40
  sta VERA_data0
  lda COLOR
  sta VERA_data0
  pla
  rts
.endproc
