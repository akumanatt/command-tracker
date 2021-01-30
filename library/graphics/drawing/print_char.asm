; Print letter to VERA (which requires simple math)
; a = char value
.proc print_char
  COLOR = r0
print_char:
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
