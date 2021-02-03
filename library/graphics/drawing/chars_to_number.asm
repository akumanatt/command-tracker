; Convert screencodes to hex numbers
; For numbers, subtract $30 ($2F with carry)
; For A-F, add $09

  ; Constants
  CHAR_G = $07

  ; Vars
  HIGH_BYTE = r0
  LOW_BYTE = r1

  TEMP = r15
  ; Value in a
.proc chars_to_number
chars_to_number:
@first_number:
  lda r0
  jsr convert_to_number
  rol
  rol
  rol
  rol
  sta TEMP
@second_number:
  lda r1
  jsr convert_to_number
@end:
  ora TEMP
  rts

convert_to_number:
  cmp #CHAR_G
  bpl @number
@letter:
  clc
  adc #$09 ; Add 9
  rts
@number:
  sbc #$30 ; Subtract $30 (incl. carry)
  rts

.endproc
