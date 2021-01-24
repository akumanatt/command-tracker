; Print a 16-bit hex value stored in the accumulator to the screen

; r0 = lower half
; r0+1 = upper half
printhex16:
  lda r0
  jsr printhex
  lda r0+1
  jsr printhex
  rts
