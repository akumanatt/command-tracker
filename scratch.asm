.include "library/preamble.asm"
.include "library/x16.inc"
.include "library/macros.inc"
.include "library/math/mulby12.asm"
.include "library/drawing/clearvram.asm"
.include "library/drawing/vera/gotoxy.asm"
.include "library/printing/printhex.asm"
.include "library/printing/vera/printhex.asm"
.include "library/printing/vera/printchar.asm"

.include "variables.inc"

start:
.include "setup.asm"

  vera_stride #$10

  lda #CURRENT_ROW_X
  ldy #CURRENT_ROW_Y
  jsr vera_goto_xy


  lda color
  sta r0
  lda VERA_L0_tilebase
  jsr printhex_vera
  lda VERA_L1_tilebase
  jsr printhex_vera

  rts

lettera: .byte "a"
letterb: .byte "b"
color: .byte $1C
