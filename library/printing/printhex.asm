; Print an 8-bit hex value stored in the accumulator to the screen

; .include "x16.inc"

; First we shift 4-bits to the right. This is so we can print the first
;   character of the number.
printhex:
  phx
  pha
  jsr @main
  pla
  plx
  rts

@main:
  tax
  lsr
  lsr
  lsr
  lsr
  jsr @printc
  txa
  and #$0f

; Print a single character. If it's 0-9, add the value of the '0' symbol
;   in PETSCII. Since numbers are sequential, it maps nicely.
;   Otherwise, map it to the 'A' key and do the same thing. Not the
;   subtraction looks a bit weird because of how carry works.
;   We also actually start at the '@' character but subtract down to a
;   minimum value of 1 to avoid having to treat 0 as a special case.
;   The next character in PETSCII after '@' is 'A'.
@printc:    cmp #$0a
            bcs @printl
@printn:    adc #CHAR0
            jsr CHROUT
            rts

@printl:    clc
            sbc #$08
            clc
            adc #CHARAT
            jsr CHROUT
            rts
