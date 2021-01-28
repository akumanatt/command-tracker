.proc play_row
  VERA_VOICE_OFFSET = r2    ; for skipping through VERA registers
  CHANNEL_COUNT = r4   ; Counter to know when we're done with channels
  CHANNEL_OFFSET = r6 ; bytes to skip for each channel
play_row:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med

  lda #$00
  sta VERA_VOICE_OFFSET
  sta CHANNEL_OFFSET

  lda #NUMBER_OF_CHANNELS
  sta CHANNEL_COUNT

@channel:
  ldy CHANNEL_OFFSET  ; note is first byte
  lda (ROW_POINTER),y ;get note from the pattern
  jsr @note
  jsr @inst
  jsr @vol
  jsr @effect

  lda VERA_VOICE_OFFSET
  clc
  adc #NUM_VERA_PSG_REGISTERS
  sta VERA_VOICE_OFFSET

  lda CHANNEL_OFFSET
  clc
  adc #TOTAL_BYTES_PER_CHANNEL
  sta CHANNEL_OFFSET

  dec CHANNEL_COUNT
  bne @channel
@end:
  rts

@note:
  ; Get numeric value of note
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
  beq @note_end

@note_play:
  ;$1F9C0 - $1F9FF
  ; low the low byte of Note
  lda #$C0
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low
  lda pitch_dataL,x
  sta VERA_data0
  ; load high byte of note
  lda #$C1
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low
  lda pitch_dataH,x
  sta VERA_data0

  jmp @note_end

@note_off:
  lda #$C2
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low
  lda #$00
  sta VERA_data0

@note_end:
  rts

@inst:
  ; placeholder, do nothing but jump past the byte
  lda #$01  ; inst is second byte
  clc
  adc VERA_VOICE_OFFSET
  rts

@vol:
  ; Set Vol

  lda #$C2
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low

  ldy #$02    ; vol is third byte
  adc CHANNEL_OFFSET
  lda (ROW_POINTER),y ;get vol from the pattern
  cmp #VOLNULL         ; if null, skip to effect section
  ; For now we force panning to LR
  ora #%11000000
  sta VERA_data0
  rts

; effect
@effect:
  ; nothing yet
  rts

  ;jmp @end


.endproc
