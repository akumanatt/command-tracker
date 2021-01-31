.include "includes.inc"

start:
  sei
  jsr setup
  jsr ui::draw_frame

  rts
;.include "pattern.inc"
.include "data.inc"
