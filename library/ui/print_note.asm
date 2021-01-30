; Print the tracker representation of a note
; (e.g. C-4)
.proc print_note
  COLOR = r0
print_note:
  phx
  pha
  ldx NOTE_NOTE
  lda note_names,x
  jsr graphics::drawing::print_char
  lda note_sharps,x
  jsr graphics::drawing::print_char
  cpx #NOTEREL
  beq @print_rel_octave
  cpx #NOTEOFF
  beq @print_off_octave
  cpx #NOTENULL
  beq @print_null_octave
  lda NOTE_OCTAVE
  adc #$30  ; to PETSCII start of numbers
  jmp @print_note_end
@print_rel_octave:
  lda #PETSCII_UP_ARROW
  jmp @print_note_end
@print_off_octave:
  lda #PETSCII_DASH
  jmp @print_note_end
@print_null_octave:
  lda #PETSCII_PERIOD
@print_note_end:
  jsr graphics::drawing::print_char
  pla
  plx
  rts
.endproc
