.proc print_pattern
  ROW_POINTER = r11 ; 16-bit address for keeping track of bytes
print_pattern:
  ; Set stride to 1, high bit to 1
  lda #$11
  sta VERA_addr_high

  ; Start at the first row
  lda #<PATTERN_POINTER
  sta ROW_POINTER
  lda #>PATTERN_POINTER
  sta ROW_POINTER+1

  ; row count
  ldx #$00

  ; For the loop, y is the offset of the channel data
@loop:
@print_row:
  ; set position to x=0 and y=row count
  txa
  tay
  lda #$00  ; set x-pos to 0
  jsr vera_goto_xy    ; y-pos is y register

@print_row_number:
  ; Print row number
  set_text_color #PATTERN_ROW_NUMBER_COLOR
  txa ; is row number
  jsr printhex_vera

  ; Move over one (for bar on top layer)
  lda $00
  sta r0
  jsr print_char_vera

  ; Offset for bytes of row
  ldy #$00  ; offset for row data
  ; Print note
  lda (ROW_POINTER),y

  jsr decode_note
  set_text_color #PATTERN_ROW_NUMBER_COLOR
  jsr print_note

  jsr @print_inst
  jsr @print_vol
  jsr @print_effect

@jump_to_next_row:
    ; Using something like this in getrow too so probably a function?
    clc
    lda ROW_POINTER
    adc #TOTAL_BYTES_PER_ROW
    sta ROW_POINTER
    lda ROW_POINTER+1
    adc #$00
    sta ROW_POINTER+1

  ;lda ROW_POINTER
  ;adc #$02
  ;sta ROW_POINTER

@inc_row_count:
  ; remember x is row count
  inx
  cpx #ROW_MAX
  bne @loop
@end:
  rts

@print_inst:
  set_text_color #PATTERN_INST_COLOR
  iny
  lda (ROW_POINTER),y
  cmp #INSTNULL
  bne @setinst
@nullinst:
  lda #CHAR_DOT
  jsr print_char_vera
  lda #CHAR_DOT
  jsr print_char_vera
  rts
@setinst:
  jsr printhex_vera
  rts

@print_vol:
  ; Print vol
  set_text_color #PATTERN_VOL_COLOR
  iny
  lda (ROW_POINTER),y
  cmp #VOLNULL
  bne @setvol
@nullvol:
  lda #CHAR_DOT
  jsr print_char_vera
  lda #CHAR_DOT
  jsr print_char_vera
  rts
@setvol:
  jsr printhex_vera
  rts

@print_effect:
  set_text_color #PATTERN_EFX_COLOR
  iny
  lda (ROW_POINTER),y
  cmp #EFFNULL
  bne @seteffect
@nulleffect:
  lda #CHAR_DOT
  jsr print_char_vera
  lda #CHAR_DOT
  jsr print_char_vera
  lda #CHAR_DOT
  jsr print_char_vera
  lda #CHAR_DOT
  jsr print_char_vera
  rts
@seteffect:
  jsr printhex_vera
  iny
  lda (ROW_POINTER),y
  jsr printhex_vera
  rts

.endproc
