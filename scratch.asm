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
  ; r1 is used by MEMORY_COPY
  ; r13 is used by math::sort8
  ; Just trying to save a few cycles by doing this all at once
  sta r1
  sta r13
  lda #>order_list_sorted
  sta r1+1
  sta r13+1
  lda #$FF
  ; Same as above, r2 used by MEMORY_COPY, r14 by sort8
  sta r2
  sta r14
  jsr MEMORY_COPY
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
