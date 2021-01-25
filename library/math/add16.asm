; Add two 16-bit numbers
.proc add16
  NUM1 = r0
  NUM2 = r1
  RES = r2
  add16:
    clc
    lda NUM1
    adc NUM2
    sta RES
    lda NUM1+1
    adc NUM2+1
    sta RES+1
    rts
.endproc
