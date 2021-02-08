.proc clear_lower_frame

clear_lower_frame:
  lda #$10
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1
  ; X/Y Start
  lda #$01
  sta r0
  lda #$06
  sta r1
  ; X End
  lda #$4E
  sta r2
  ; Y End
  lda #$35
  sta r3
  lda #HEADER_BACKGROUND_COLOR
  sta r4
  jsr graphics::drawing::draw_solid_box
  rts
.endproc
