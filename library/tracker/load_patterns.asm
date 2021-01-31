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

  ;pattern1
  lda #$01
  sta RAM_BANK
  lda #<TOTAL_BYTES_PER_PATTERN
  sta BYTES
  lda #>TOTAL_BYTES_PER_PATTERN
  sta BYTES + 1
  lda #<pattern1
  sta SOURCE
  lda #>pattern1
  sta SOURCE + 1
  jsr MEMORY_COPY

  ;pattern 2
  lda #$02
  sta RAM_BANK
  lda #<TOTAL_BYTES_PER_PATTERN
  sta BYTES
  lda #>TOTAL_BYTES_PER_PATTERN
  sta BYTES + 1
  lda #<pattern2
  sta SOURCE
  lda #>pattern2
  sta SOURCE + 1
  jsr MEMORY_COPY

  ;pattern 3
  lda #$03
  sta RAM_BANK
  lda #<TOTAL_BYTES_PER_PATTERN
  sta BYTES
  lda #>TOTAL_BYTES_PER_PATTERN
  sta BYTES + 1
  lda #<pattern3
  sta SOURCE
  lda #>pattern3
  sta SOURCE + 1
  jsr MEMORY_COPY

  ;pattern 3
  lda #$04
  sta RAM_BANK
  lda #<TOTAL_BYTES_PER_PATTERN
  sta BYTES
  lda #>TOTAL_BYTES_PER_PATTERN
  sta BYTES + 1
  lda #<pattern4
  sta SOURCE
  lda #>pattern4
  sta SOURCE + 1
  jsr MEMORY_COPY

  rts
.endproc
