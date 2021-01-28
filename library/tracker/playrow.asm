.proc play_row
play_row:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med

  ; y is our offset WITHIN THE ROW
  ldy #$00

@note:
  ; Get numeric value of note
  lda (ROW_POINTER),y ;get note from the pattern
  jsr decode_note

; SUggestion from klip, though I need to think through this more
; Should save quite a few cycles
;lda octave
;asl
;asl
;sta pitch
;asl
;clc
;adc pitch
;sta pitch

  jsr mulby12
  adc NOTE_NOTE
  sta NOTE_NUMERIC
  tax

  lda NOTE_NOTE
  cmp #NOTEREL
  beq @note_off     ; same as note off for now
  cmp #NOTEOFF
  beq @note_off
  cmp #NOTENULL ;if null, skip playing note
  beq @effect

@note_play:
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
  jmp @inst

@note_off:
  lda #$C2
  sta VERA_addr_low
  lda #$00
  sta VERA_data0
  iny
  iny
  jmp @effect

@inst:
  ; placeholder, do nothing but jump past the byte
  ldy #$01
  ;lda (ROW_POINTER),y ;get vol from the pattern
  ;jsr printhex

@vol:
  ; Set Vol
  ; For now we force panning to LR
  lda #$C2
  sta VERA_addr_low
  ldy #$02
  lda (ROW_POINTER),y ;get vol from the pattern
  cmp #VOLNULL         ; if null, skip to effect section
  ora #%11000000
  sta VERA_data0

; effect
@effect:
  ; nothing yet
  ldy #$03


  jmp @end

@end:
  rts

.endproc
