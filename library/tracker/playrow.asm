.proc play_row
play_row:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med

  ; y is our offset WITHIN THE ROW
  ldy #$00
  lda (ROW_POINTER),y ;get note from the pattern
  jsr decode_note

  ; Get numeric value of note
  jsr mulby12
  adc NOTE_NOTE
  sta NOTE_NUMERIC
  tax

  lda NOTE_NOTE
  cmp #NOTEREL
  beq @note_off     ; same as note off for now
  cmp #NOTEOFF
  beq @note_off
  cmp #NOTENULL ;if null, evaluate volume and skip playing note
  beq @vol

  ;$1F9C0 - $1F9FF
  ; low the low byte of Note
  lda #$C0
  sta VERA_addr_low
  lda pitch_dataL,x
  sta VERA_data0
  ; load high byte of note
  lda #$C1
  sta VERA_addr_low
  lda pitch_dataH,x
  sta VERA_data0

@vol:
  ; Set Vol
  ; For now we force panning to LR
  lda #$C2
  sta VERA_addr_low
  iny
  lda (ROW_POINTER),y ;get vol from the pattern
  cmp VOLNULL         ; if null, skip to effect section
  jsr @effect
  ora #%11000000
  sta VERA_data0

; effect
@effect:
  ; nothing yet
  jmp @end

@note_off:
  lda #$C2
  sta VERA_addr_low
  lda #$00
  sta VERA_data0
@end:
  rts

.endproc
