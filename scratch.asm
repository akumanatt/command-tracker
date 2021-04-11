; Scratch

.include "includes.inc"

start:

main:
loop:
  jsr jump_routine
  jmp loop

jump_routine:
  lda #$01
  tax
  lda jump_table_test_low,x
  sta r15
  lda jump_table_test_low,x
  sta r15+1
  jmp (r15)
  rts




jump_table_test_low:
  .byte <hello
  .byte <hello2
jump_table_test_high:
  .byte >hello
  .byte >hello2

hello:
  lda #$00
  jsr debug::printhex
  ;jmp main
  rts

hello2:
  lda #$01
  jsr debug::printhex
  ;jmp hello
  rts

.include "data.inc"
