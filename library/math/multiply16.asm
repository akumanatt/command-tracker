;------------------------
; Modified from https://codebase64.org/doku.php?id=base:8bit_multiplication_16bit_product
; Most code is original but I updated it to use ZP's

; 8bit * 8bit = 16bit multiply
; By White Flame
; Multiplies "num1" by "num2" and stores result in .A (low byte, also in .X) and .Y (high byte)
; uses extra zp var "num1Hi"

; .X and .Y get clobbered.  Change the tax/txa and tay/tya to stack or zp storage if this is an issue.
;  idea to store 16-bit accumulator in .X and .Y instead of zp from bogax

; In this version, both inputs must be unsigned
; Remove the noted line to turn this into a 16bit(either) * 8bit(unsigned) = 16bit multiply.

.proc multiply16
  NUM1 = r0
  NUM2 = r1
multiply16:

  ; Return low byte = a and x
  ; Hi byte = y
 lda #$00
 tay
 sty NUM1+1  ; remove this line for 16*8=16bit multiply
 beq @enterLoop

@doAdd:
 clc
 adc NUM1
 tax

 tya
 adc NUM1+1
 tay
 txa

@loop:
 asl NUM1
 rol NUM1+1
@enterLoop:  ; accumulating multiply entry point (enter with .A=lo, .Y=hi)
 lsr NUM2
 bcs @doAdd
 bne @loop

@end:
  rts
.endproc
