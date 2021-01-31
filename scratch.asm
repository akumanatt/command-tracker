.include "includes.inc"

start:
  sei
  jsr setup
  jsr ui::draw_frame
  ;jsr ui::draw_pattern_frame
  jsr ui::draw_orders_frame

loop:
  jsr GETIN  ;keyboard
  jsr graphics::kernal::printhex
  jmp loop

  rts
;.include "pattern.inc"
.include "data.inc"
