.macro set_note_off
  smb7 NOTE_FLAGS
.endmacro

.macro set_note_rel
  smb6 NOTE_FLAGS
.endmacro

.macro set_note_play
  smb4 NOTE_FLAGS
.endmacro

.proc play_row
  VERA_VOICE_OFFSET = r2    ; for skipping through VERA registers
  CHANNEL_COUNT = r4   ; Counter to know when we're done with channels
  CHANNEL_OFFSET = r6 ; bytes to skip for each channel
  NOTE_FLAGS = r7   ; bit 7 = noteoff, bit 6 = noterel, bit 5 =
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

@channel_loop:
  lda #$00
  sta NOTE_FLAGS
  ldy CHANNEL_OFFSET  ; note is first byte
  lda (ROW_POINTER),y ;get note from the pattern
  jsr @effect
  jsr @note
  jsr @inst
  jsr @vol

  lda VERA_VOICE_OFFSET
  clc
  adc #NUM_VERA_PSG_REGISTERS
  sta VERA_VOICE_OFFSET

  lda CHANNEL_OFFSET
  clc
  adc #TOTAL_BYTES_PER_CHANNEL
  sta CHANNEL_OFFSET

  dec CHANNEL_COUNT
  bne @channel_loop
@end:
  rts

@note:
  ; Get numeric value of note
  jsr sound::decode_note

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

  jsr math::multiply_by_12
  adc NOTE_NOTE
  sta NOTE_NUMERIC
  tax

  lda NOTE_NOTE
  cmp #NOTEREL
  beq @note_off     ; same as note off for now
  cmp #NOTEOFF
  beq @note_off
  cmp #NOTENULL     ;if null, skip playing note
  beq @note_end

@note_play:
  ;$1F9C0 - $1F9FF
  ; set low byte of Note
  set_note_play
  lda #$C0
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low
  lda sound::pitch_dataL,x
  sta VERA_data0
  ; set high byte of note
  lda #$C1
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low
  lda sound::pitch_dataH,x
  sta VERA_data0

  jmp @note_end

@note_off:
  set_note_off

  ; debug
  ;lda NOTE_FLAGS
  ;jsr printhex

  ;lda #$C2
  ;clc
  ;adc VERA_VOICE_OFFSET
  ;sta VERA_addr_low
  ;lda #$00
  ;sta VERA_data0

@note_end:
  rts

@inst:
  ; placeholder, do nothing but jump past the byte
  lda #$01  ; inst is second byte
  clc
  adc VERA_VOICE_OFFSET
  rts

; Set Vol
@vol:
  lda #$C2
  clc
  adc VERA_VOICE_OFFSET
  sta VERA_addr_low

  ; Skip if we have a note off event
  ; Need to add not rel once it exists
@vol_skip_on_note_off:
  lda #NOTEOFF_FLAG
  bit NOTE_FLAGS
  beq @set_vol_from_pattern
  lda #$00
  sta VERA_data0
  jmp @end_vol

@set_vol_from_pattern:
  lda #$02    ; vol is third byte
  clc
  adc CHANNEL_OFFSET
  tay
  lda (ROW_POINTER),y ;get vol from the pattern
  cmp #VOLNULL         ; if null, skip to instrument default
  beq @set_vol_from_instrument

  ; For now we force panning to LR
  ora #%11000000
  sta VERA_data0
  rts

; If we played an instrument but didn't specify a volume,
; use the instrument's default
@set_vol_from_instrument:
  lda #NOTEPLAY_FLAG
  bit NOTE_FLAGS
  beq @end_vol
  ; we have no instruments defined so we set to max
  lda #$FF
  sta VERA_data0

@end_vol:
  rts


; effect
@effect:
  ; nothing yet
  rts

  ;jmp @end



.endproc
