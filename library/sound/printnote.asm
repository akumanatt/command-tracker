.proc print_note
print_note:
  ldx NOTE_NOTE
  lda note_names,x
  jsr CHROUT
  lda note_sharps,x
  jsr CHROUT
  cpx #NOTEREL
  beq print_rel_octave
  cpx #NOTEOFF
  beq print_off_octave
  cpx #NOTENULL
  beq print_null_octave
  lda NOTE_OCTAVE
  adc #$30  ; to PETSCII start of numbers
  jmp print_note_end
print_rel_octave:
  lda #PETSCII_UP_ARROW
  jmp print_note_end
print_off_octave:
  lda #PETSCII_DASH
  jmp print_note_end
print_null_octave:
  lda #PETSCII_PERIOD
print_note_end:
  jsr CHROUT
  rts
.endproc
