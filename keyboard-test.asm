.include "includes.inc"

start:
main:
  wai
  jsr GETIN  ;keyboard
  jsr debug::printhex
  jmp main

.include "data.inc"
