; Draw a framed box
.proc draw_rounded_box
  ; Constants
  TOP_LEFT_CORNER = $55
  TOP_RIGHT_CORNER = $49
  BOTTOM_LEFT_CORNER = $4A
  BOTTOM_RIGHT_CORNER = $4B

  ; Vars
  BOX_X1 = r0
  BOX_X2 = r2
  BOX_Y1 = r3
  BOX_Y2 = r4
  COLOR = r4
  COUNT = r15
@draw_rounded_box:
  lda #$01
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1

; First line
@first_line_loop:
  lda BOX_X1
  ldy BOX_Y1
  jsr goto_xy
  lda #TOP_LEFT_CORNER
  jsr print_char
  jsr print_char
  jsr print_char
  jsr print_char

@end:
  rts
.endproc
