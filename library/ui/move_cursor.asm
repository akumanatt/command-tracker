
.proc cursor_up
cursor_up:
  jsr graphics::drawing::cursor_unplot
  lda cursor_y
  sbc #$00
  sta cursor_y
  jsr graphics::drawing::cursor_plot
  jsr inc_vera
  rts
.endproc

.proc cursor_down
cursor_down:
  jsr graphics::drawing::cursor_unplot
  lda cursor_y
  clc
  adc #$01
  sta cursor_y
  jsr graphics::drawing::cursor_plot
  jsr inc_vera
  rts
.endproc

.proc cursor_left
cursor_left:
  jsr graphics::drawing::cursor_unplot
  lda cursor_x
  sbc #$00
  sta cursor_x
  jsr graphics::drawing::cursor_plot
  jsr inc_vera
  rts
.endproc

.proc cursor_right
cursor_right:
  jsr graphics::drawing::cursor_unplot
  lda cursor_x
  clc
  adc #$01
  sta cursor_x
  jsr graphics::drawing::cursor_plot
  jsr inc_vera
  rts
.endproc

inc_vera:
  ldx VERA_addr_low
  inx
  stx VERA_addr_low
  rts
