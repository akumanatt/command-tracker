; The main application which is responsible for calling different modules

.include "includes.inc"

; Con
start:
  jsr setup
main:
  ;jsr tracker::save_song
  ;jsr tracker::load_song
  lda #$20
  sta VERA_addr_high
  stz VERA_addr_med
  stz VERA_addr_low
  lda #$0D
  sta VERA_data0

  lda #$0F
  sta r0
  lda #$4D
  jsr graphics::drawing::print_alpha_char
  lda #$4D
  jsr graphics::drawing::print_alpha_char
  lda #$4D
  jsr graphics::drawing::print_alpha_char
  lda #$4D
  jsr graphics::drawing::print_alpha_char


  ;jmp tracker::exit
loop:
  jmp loop



.include "data.inc"
