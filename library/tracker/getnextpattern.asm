.proc get_next_pattern
get_next_pattern:
  lda ROW_COUNT
  clc
  adc #$01
  cmp #ROW_MAX
  bne @return
  ; If we're on the last order, start over
  ldy ORDER_NUMBER
  cpy order_list_length
  beq @start_over
  ; Otherwise go to the next order
  iny
@load_next_pattern:
  sty ORDER_NUMBER
  lda order_list,y
  sta RAM_BANK
  sta PATTERN_NUMBER
  jsr print_pattern
  jsr print_current_order
  jsr print_current_pattern_number
  rts

@start_over:
  ldy #$00
  sty ORDER_NUMBER
  jmp @load_next_pattern

@return:
  rts
.endproc
