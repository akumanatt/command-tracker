.proc get_pattern
get_pattern:
  ; Get hardcoded pattern in Hi-RAM
  lda #$01
  sta RAM_BANK
  ;lda #<pattern1
  ;sta PATTERN_POINTER
  ;lda #>pattern1
  ;sta PATTERN_POINTER+1

  ; Part of the pattern fetch code? Will be replaced by
  ; routines to jump to hiram
  ;lda #<pattern1
  ;sta PATTERN_POINTER
  ;lda #>pattern1
  ;sta PATTERN_POINTER+1
  ;rts
.endproc
