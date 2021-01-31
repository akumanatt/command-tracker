.include "includes.inc"

start:
  sei
  jsr setup
  jsr ui::draw_frame
  jsr ui::draw_pattern_frame

  

  rts
;.include "pattern.inc"
.include "data.inc"
