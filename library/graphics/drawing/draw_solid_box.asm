; Draw a solid box
.proc draw_solid_box
  ; Constants
  ;SPACE = $20
  SPACE = $4F
  ; Vars
  BOX_X = r0
  BOX_Y = r1
  BOX_X_LEN = r2
  BOX_Y_LEN = r3
  COLOR = r4
  ; Temp
  COUNT_Y = r6
  ;BOX_Y_END = r7

  draw_solid_box:
    lda #$0
    sta COUNT_Y
  @loopy:
    lda BOX_X_LEN
    ldx BOX_X
    ldy BOX_Y
  @line:
    lda r2
    txa
    asl
    sta VERA_addr_low
    sty VERA_addr_med
    ldx 0
  @line_loop:
    lda #SPACE
    sta VERA_data0 ; Write chracter
    lda COLOR
    sta VERA_data0 ; Write color
    inx
    cpx BOX_X_LEN
    bne @line_loop

@end_line_loop:
    inc COUNT_Y
    inc BOX_Y
    ldy COUNT_Y
    cpy BOX_Y_LEN
    bne @loopy
    rts
.endproc
