.proc print_string
  STRING_POINTER = r0
  X_POS = r1
  Y_POS = r2
  COLOR = r3
print:
  lda #$10
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1
  lda X_POS
  asl               ; shift because second byte is color
  sta VERA_addr_low
  lda Y_POS        ; y coord
  sta VERA_addr_med
  ldy #0
@loop:
  lda (STRING_POINTER),y
  beq @end
  cmp #$40               ; Only subtract if it's A-Z
  bmi @nosub
  sec                   ; Converting from PETSCII to Screen Codes
  sbc #$40
@nosub:
  sta VERA_data0
  lda COLOR
  sta VERA_data0
  iny
  bne   @loop
@end:
  rts
.endproc
