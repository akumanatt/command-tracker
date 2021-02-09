; Convert screencodes to hex numbers
; For numbers, subtract $30 ($2F with carry)
; For A-F, add $09
.proc chars_to_number

  ; Constants
  CHAR_G = $07

  ; Vars
  HIGH_BYTE = r0
  LOW_BYTE = r1
  TEMP = r15
  ; Returns result in a

chars_to_number:
@first_number:
  lda r0
  jsr convert_to_number
  asl
  asl
  asl
  asl
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
  ; Ignore the top half (we only care about 0-9)
  ; This sorta subtracts by $30 (or rather just ignores it)
  and #%00001111
  rts

.endproc
