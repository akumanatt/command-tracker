; Print raw character to VERA 
; a = char value
.proc print_alpha_char
  COLOR = r0
print_alpha_char:
  cmp #$40               ; Only subtract if it's A-Z
  bmi @nosub
  sec                   ; Converting from PETSCII to Screen Codes
  sbc #$40
  clc
@nosub:
  sta VERA_data0
  lda COLOR
  sta VERA_data0

  rts
.endproc
