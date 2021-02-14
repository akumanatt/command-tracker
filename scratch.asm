; The main application which is responsible for calling different modules

.include "includes.inc"

; Con
start:
main:
  jsr tracker::save_song
  rts

.include "data.inc"
