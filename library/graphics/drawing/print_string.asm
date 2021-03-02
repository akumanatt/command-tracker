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
  cmp #SCREENCODE_RETURN  ; Our special screencode value to indicate return
  ;cmp #$0D                ; If return is found, go down a row
  beq @return
  cmp #$40               ; Only subtract if it's A-Z
  bmi @nosub
  sec                   ; Converting from PETSCII to Screen Codes
  sbc #$40
  jmp @nosub
@return:
  lda X_POS
  asl               ; shift because second byte is color
  sta VERA_addr_low
  ldx Y_POS        ; y coord
  inx
  stx VERA_addr_med
  stx Y_POS
  jmp @loop_end
@nosub:
  sta VERA_data0
  lda COLOR
  sta VERA_data0
@loop_end:
  iny
  bne   @loop
@end:
  rts
.endproc
