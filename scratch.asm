; The main application which is responsible for calling different modules

.include "includes.inc"

; Con
start:
  jsr setup
main:
  jsr tracker::save_song


;@loop:
  ;jmp @loop
  rts

.include "data.inc"
