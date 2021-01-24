; Returns result in A
.proc mod8
  NUM1 = r0
  NUM2 = r1

mod8:
		lda r0  ; memory addr A
		sec
@modulus:
    sbc r1  ; memory addr B
		bcs @modulus
		adc r1
    rts
.endproc
