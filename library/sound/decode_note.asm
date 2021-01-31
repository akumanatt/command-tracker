; a = un-decoded note (hi-nibble = pitch, low-nibble = note)
.proc decode_note
  ; Get note pitch and note
  pha
  ; The note is easy, we just grab the bottom nibble

  and #%00001111
  sta NOTE_NOTE

  ; The pitch is at the top so we move that down
  pla
  lsr
  lsr
  lsr
  lsr
  sta NOTE_OCTAVE
  rts
.endproc
