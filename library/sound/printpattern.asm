.proc print_pattern
print_pattern:
  phy
  pha
  ;gotocoords 10,1
  ldy #$00

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

  ; Move over one (for bar on top layer)
  lda #$1D
  jsr CHROUT

  lda pattern,y
  jsr decode_note
  ;lda NOTE_NOTE
  lda #$05 ; white
  jsr CHROUT
  jsr print_note

  ; This is just dirty for now to make it look nice
  ; (also really should be using macros here...)
  ; Vol
  lda #$1F  ; blue
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT

  ;Effect
  lda #$9C ; purple
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT
  lda #$2E
  jsr CHROUT

  lda #$05 ; white
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
