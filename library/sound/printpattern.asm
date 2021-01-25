.proc print_pattern
print_pattern:
  phy
  pha
  ;gotocoords 10,1
  ldy #$00

  lda #$12
  jsr CHROUT

@loop:
  phy
  tya
  tax
  clc
  adc #$0A
  tax
  ldy   #$01    ; xpos (confusingly)
  clc
  jsr   PLOT
  ply
  tya
  jsr printhex

  lda #$62  ;bar
  jsr CHROUT

  lda pattern,y
  jsr decode_note
  ;lda NOTE_NOTE
  jsr print_note

  ; This is just dirty for now to make it look nice
  ; (also really should be using macros here...)
  lda #$1D
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT

  lda #$1D
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT

  lda #$1D
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT

  lda #$0D  ;return
  jsr CHROUT

  iny
  cpy #ROW_MAX
  bne @loop
@end:

  pla
  ply
  rts
.endproc
