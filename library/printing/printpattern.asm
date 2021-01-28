
.proc print_pattern
  ROW_POINTER   = r11 ; 16-bit address for keeping track of bytes
  BACKGROUND_COLOR = r12  ; temp storage for background color mask
  CHANNEL_COUNT = r13    ; Counter to know when we're done with channels

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
; First check for row highlights
  jsr @check_highlight_rows

@print_row:
  ; set position to x=0 and y=row count
  txa
  tay
  lda #$00  ; set x-pos to 0
  jsr vera_goto_xy    ; y-pos is y register
  jsr @print_row_number

  ; Offset for bytes of row
  ldy #$00  ; offset for row data

@channels_loop:
  lda (ROW_POINTER),y
  jsr decode_note
  set_background_foregound_text_color BACKGROUND_COLOR, #PATTERN_ROW_NUMBER_COLOR
  jsr print_note
  jsr @print_inst
  jsr @print_vol
  jsr @print_effect
  iny ; This is for the decode_note section when we loop after the first row
  ; Move over one (for bar on top layer)
  lda $00
  sta r0
  jsr print_char_vera

  dec CHANNEL_COUNT
  bne @channels_loop

  jsr @jump_to_next_row


@inc_row_count:
  ; remember x is row count
  inx
  cpx #ROW_MAX
  bne @loop
@end:
  rts


; Print row number
@print_row_number:
  set_background_foregound_text_color BACKGROUND_COLOR, #PATTERN_ROW_NUMBER_COLOR

  ;set_text_color #PATTERN_ROW_NUMBER_COLOR
  txa ; is row number
  jsr printhex_vera

  ; Move over one (for bar on top layer)
  lda $00
  sta r0
  jsr print_char_vera

  ; Reset channel counter
  lda #NUMBER_OF_CHANNELS
  sta CHANNEL_COUNT
  rts

@print_inst:
  set_background_foregound_text_color BACKGROUND_COLOR, #PATTERN_INST_COLOR
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
  set_background_foregound_text_color BACKGROUND_COLOR, #PATTERN_VOL_COLOR
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
  set_background_foregound_text_color BACKGROUND_COLOR, #PATTERN_EFX_COLOR
  iny ; effect number
  lda (ROW_POINTER),y
  iny ; effect data
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
  ;iny
  lda (ROW_POINTER),y
  jsr printhex_vera
  rts


@jump_to_next_row:
    ; Using something like this in getrow too so probably a function?
    clc
    lda ROW_POINTER
    adc #TOTAL_BYTES_PER_ROW
    sta ROW_POINTER
    lda ROW_POINTER+1
    adc #$00
    sta ROW_POINTER+1

    ; Reset channel counter
    lda #NUMBER_OF_CHANNELS
    sta CHANNEL_COUNT
    rts

; Set flags for when to highlight major/minor rows
@check_highlight_rows:
@check_major_highlight:
  txa   ; current row
  sta r0
  lda #ROW_MAJOR
  sta r1
  jsr mod8
  beq @set_major_highlight
  ;rmb7 HIGHLIGHT_FLAGS  ; clear if it's not a highlight
  jmp @check_minor_highlight
@set_major_highlight:
  ;smb7 HIGHLIGHT_FLAGS
  lda #MAJOR_HIGHLIGHT_COLOR
  sta BACKGROUND_COLOR
  rts
@check_minor_highlight:
  txa
  sta r0
  lda #ROW_MINOR
  sta r1
  jsr mod8
  beq @set_minor_highlight
  ;rmb6 HIGHLIGHT_FLAGS  ; clear if it's not a highlight
  jmp @no_highlight
@set_minor_highlight:
  ;smb6 HIGHLIGHT_FLAGS
  lda #MINOR_HIGHLIGHT_COLOR
  sta BACKGROUND_COLOR
  rts
@no_highlight:
  lda #PATTERN_BACKGROUND_COLOR
  sta BACKGROUND_COLOR
  rts
.endproc
