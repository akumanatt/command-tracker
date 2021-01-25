.include "library/preamble.asm"
.include "library/x16.inc"
.include "library/macros.inc"
.include "library/math/mulby12.asm"
.include "library/drawing/clearscreen.asm"
.include "library/printing/printhex.asm"

start:
  lda VERA_L0_config
  jsr printhex
  lda VERA_L1_config
  jsr printhex
  lda VERA_dc_video
  jsr printhex

  lda VERA_L0_mapbase
  jsr printhex
  lda VERA_L1_mapbase
  jsr printhex

  lda VERA_L0_tilebase
  jsr printhex
  lda VERA_L0_tilebase
  jsr printhex

  lda #%0011001
  sta VERA_dc_video
  ;jsr clear_screen


  lda #$01
  jsr CHROUT

  lda #$41
  jsr CHROUT
  lda #$C1
  jsr CHROUT

  rts
