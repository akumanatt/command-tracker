.proc get_pattern
get_pattern:
  ; Part of the pattern fetch code? Will be replaced by
  ; routines to jump to hiram
  lda #<pattern
  sta PATTERN_POINTER
  lda #>pattern
  sta PATTERN_POINTER+1
  rts
.endproc
