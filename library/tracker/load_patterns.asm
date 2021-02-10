; Loads all the patterns into hiram
; (for now they're just byte arrays)
.proc load_patterns
  ;params for MEMORY_COPY
  SOURCE = r0
  DESTINATION = r1
  BYTES = r2
load_patterns:
  lda #<PATTERN_POINTER
  sta DESTINATION
  lda #>PATTERN_POINTER
  sta DESTINATION+1

  ; Fill with empty patterns for now
  ldx #$01
@empty_patterns_loop:
  stx RAM_BANK
  phx
  lda #<PATTERN_POINTER
  sta r0
  lda #>PATTERN_POINTER
  sta r0 + 1

  lda #$00
  sta r1
  lda #$20
  sta r1 + 1

  lda #$FF
  jsr MEMORY_FILL
  plx
  inx
  cpx #$10
  bne @empty_patterns_loop

  rts
.endproc
