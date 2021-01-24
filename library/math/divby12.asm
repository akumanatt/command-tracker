; Divide a by 12, return result as a
.proc divby12
divby12:
  lsr
  lsr
  sta  r15
  lsr
  adc  r15
  ror
  lsr
  adc  r15
  ror
  lsr
  adc  r15
  ror
  lsr
  ;jsr printhex
  rts
.endproc
