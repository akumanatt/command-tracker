.include "includes.inc"

start:
  sei
  jsr setup
  rts
  lda #$10
  sta r0
  sta r1
  lda #$20
  sta r2
  sta r3
  lda #$F5
  sta r4
  jsr graphics::drawing::draw_rounded_box



  rts
;.include "pattern.inc"
.include "data.inc"
