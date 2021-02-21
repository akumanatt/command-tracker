; The main application which is responsible for calling different modules

.include "includes.inc"

; Con
start:
  jsr setup
main:
  ;jsr tracker::save_song
  ; Copy order list to the sorted area
  lda #<order_list
  sta r0
  lda #>order_list
  sta r0+1
  lda #<order_list_sorted
  sta r1
  lda #>order_list_sorted
  sta r1+1
  lda #$FF
  sta r2
  jsr MEMORY_COPY

  ; Now prep for sorting the list
  lda #<order_list_sorted
  sta r13
  lda #>order_list_sorted
  sta r13+1
  lda #$FF
  sta r14
  jsr math::sort8

  ; Now verify sort
  ldx #$00
@order_list_loop:
  lda order_list,x
  jsr debug::printhex
  inx
  cpx #$FF
  bne @order_list_loop

  lda #RETURN
  jsr CHROUT

  ; Now verify sort
  ldx #$00
@order_list_sorted_loop:
  lda order_list_sorted,x
  jsr debug::printhex
  inx
  cpx #$FF
  bne @order_list_sorted_loop


  rts

.include "data.inc"
