; Clear out contents of memory for pattern data
.proc clear_patterns
  ;params for MEMORY_FILL
  ADDRESS = r0
  NUM_BYTES = r1
clear_patterns:
  ; Fill with empty patterns for now
  ldx #$01
@empty_patterns_loop:
  stx RAM_BANK
  phx
  lda #<PATTERN_ADDRESS
  sta ADDRESS
  lda #>PATTERN_ADDRESS
  sta ADDRESS + 1

  lda #$00
  sta NUM_BYTES
  lda #$20
  sta NUM_BYTES + 1

  lda #$FF
  jsr MEMORY_FILL
  plx
  inx
  ;cpx #$00
  cpx #$04
  bne @empty_patterns_loop

  rts
.endproc
