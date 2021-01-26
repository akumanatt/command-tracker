; Add 8 to a 16-bit number
; Original number = r0
; Result = r0
.proc add8to16
  NUM = r0
  add16:
    clc
    lda NUM1
    adc #$08
    sta RES
    lda NUM1+1
    adc #$00
    sta NUM
    rts
.endproc
