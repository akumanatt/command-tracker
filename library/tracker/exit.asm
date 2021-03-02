; Exit program

.proc exit
  jsr disable_irq
  jsr CLALL
  lda #BASIC_ROM_BANK
  sta ROM_BANK
  rts

.endproc
