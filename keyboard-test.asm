.include "includes.inc"

start:
main:
  wai
  jsr GETIN  ;keyboard
  jsr graphics::kernal::printhex
  jmp main

.include "data.inc"
