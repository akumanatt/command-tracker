; Multiply a by 12, return result as a
.proc multiply_by_12
multiply_by_12:
  phx
  sta r11
  ldx #$0B
  clc
@loop:

  adc r11
  dex
  bne @loop
@end:
  plx
  rts
.endproc
