.include "library/preamble.asm"
.include "library/x16.inc"
.include "library/macros.inc"
.include "library/printing/printhex.asm"
.include "library/math/add16.asm"
.include "library/math/mulby12.asm"
.include "library/math/multiply16.asm"
;include "library/math/mod8.asm"
.include "library/tracker/loadpatterns.asm"
;

.include "variables.inc"

start:
;  lda #$02
;  sta r0
;  lda #$05
;  sta r1
;  jsr multiply16
;  jsr printhex
;  tya
;  jsr printhex

;  lda RAM_BANK
;  jsr printhex
;  lda #$01
;  sta RAM_BANK
;  jsr printhex
  jsr load_patterns


  rts
.include "pattern.inc"
