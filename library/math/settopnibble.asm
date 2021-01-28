;Sets the top 4 bits (the top nibble) of r1 to r0.
.proc set_top_nibble
  BYTE = r0
  TOP_NIBBLE = r1
  RESULT = r2

@set_top_nibble:
  lda BYTE
  and #%00001111
  ora TOP_NIBBLE
  sta RESULT
  rts


.endproc
