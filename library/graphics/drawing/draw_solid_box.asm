; Draw a solid box
.proc draw_solid_box
  BOX_X = r0
  BOX_Y = r1
  BOX_X_LEN = r2
  BOX_Y_LEN = r3
  COLOR = r4
  COUNT_Y = r6
  BOX_Y_END = r7

  draw_solid_box:
    lda #$0
    sta COUNT_Y
  loopy:
    lda BOX_X_LEN
    ldx BOX_X
    ldy BOX_Y
    jsr draw_line
    inc COUNT_Y
    inc BOX_Y
    ldy COUNT_Y
    cpy BOX_Y_LEN
    bne loopy
    rts
.endproc
