; Draw a line of hearts
; a = length, x,y = x/y screen coords
.proc draw_horizontal_line
  ; Vars for draw_line
  LENGTH = r11
  COLOR = r0
  CHAR = $43

  draw_horizontal_line:
    sta LENGTH
    txa
    asl
    sta VERA_addr_low
    sty VERA_addr_med
    ldx 0
  @loop:
    lda #CHAR
    sta VERA_data0 ; Write chracter
    lda COLOR
    sta VERA_data0 ; Write color
    inx
    cpx LENGTH
    bne @loop
    rts
.endproc
