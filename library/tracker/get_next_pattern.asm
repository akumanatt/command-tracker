.proc get_next_pattern
get_next_pattern:
  lda ROW_NUMBER
  clc
  adc #$01
  cmp #ROW_MAX
  bne @return
  ; If the order value is 00, we're at the end so start over
  ldy ORDER_NUMBER
  iny
  lda order_list,y
  beq @start_over
  ; Otherwise go to the next order
@load_next_pattern:
  sty ORDER_NUMBER
  lda order_list,y
  sta RAM_BANK
  sta PATTERN_NUMBER
  ; Do not draw next pattern (disabling this for now as it causes play stalls)
  ;jsr ui::print_pattern
  jsr ui::print_current_order
  jsr ui::print_current_pattern_number
  rts

@start_over:
  ldy #$00
  sty ORDER_NUMBER
  jmp @load_next_pattern

@return:
  rts
.endproc
