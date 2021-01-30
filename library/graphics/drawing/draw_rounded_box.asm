; Draw a framed box
.proc draw_rounded_box
  ; Constants
  TOP_LEFT_CORNER = $55
  TOP_RIGHT_CORNER = $49
  BOTTOM_LEFT_CORNER = $4A
  BOTTOM_RIGHT_CORNER = $4B
  VERTICAL_LINE = $42

  ; Vars
  COLOR = r0
  BOX_X1 = r1
  BOX_X2 = r2
  BOX_Y1 = r3
  BOX_Y2 = r4
  CURRENT_CHAR = r5

  COUNT = r15
@draw_rounded_box:
  lda #$10
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1

; First line
@top_left_corner:
  lda BOX_X1
  ldy BOX_Y1
  jsr goto_xy
  print_char_with_color #TOP_LEFT_CORNER, COLOR
@top_line:
  ; Length
  lda BOX_X2
  sbc #$00
  ; Start X-Pos
  ldx BOX_X1
  inx
  ; Start Y-Pos
  ldy BOX_Y1
  jsr draw_horizontal_line
@top_right_corner:
  print_char_with_color #TOP_RIGHT_CORNER, COLOR

@sides:
  ldy BOX_Y1
  iny
  jsr goto_xy
@sides_loop:
  lda BOX_X1
  jsr goto_xy
  print_char_with_color #VERTICAL_LINE, COLOR
  lda BOX_X2
  jsr goto_xy
  print_char_with_color #VERTICAL_LINE, COLOR
  iny
  cpy BOX_Y2
  bne @sides_loop
  ;lda #VERTICAL_LINE
  ;jsr

@bottom_left_corner:
  lda BOX_X1
  ldy BOX_Y2
  jsr goto_xy
  print_char_with_color #BOTTOM_LEFT_CORNER, COLOR
@bottom_line:
  ; Length
  lda BOX_X2
  sbc #$00
  ; X-Pos
  ldx BOX_X1
  inx
  ; Y-Pos
  ldy BOX_Y2
  jsr draw_horizontal_line
@bottom_right_corner:
  print_char_with_color #BOTTOM_RIGHT_CORNER, COLOR

@end:
  rts
.endproc
