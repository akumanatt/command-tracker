; Sort an 8-bit numbers in an array
; Largely used the implementation available at:
; http://www.6502.org/source/sorting/bubble8.htm

.proc sort8
  ARRAY = r13      ; Address of the array
  LENGTH = r14       ; Length of the array to sort
  EXCHANGE = r15     ; flag to denote when we are done

sort8:
  stz EXCHANGE
  ldx LENGTH
  ldy #$FF
next_element:
  lda (ARRAY),y   ; grab value
  iny
  cmp (ARRAY),y   ; and check to see if it's larger than the next one
  bcc check_end   ; no
  beq check_end   ; no
  pha             ; yes, swap elements in memory using the stack
  lda (ARRAY),y ; load the second value
  dey             ; decrement the pointer
  sta (ARRAY),y ; so we can store the second value in the first spot
  pla             ; then pull the lower value
  iny             ; increment the pointer
  sta (ARRAY),y ; and store it in the second spot
  lda #$FF        ; turn exchange flag on
  sta EXCHANGE
check_end:
  dex               ; check if we're at the end of the list
  bne next_element  ; if not,
  bit EXCHANGE      ; check the exchange flag
  bmi sort8         ; and if it's not set, go through list again
  rts

 .endproc
