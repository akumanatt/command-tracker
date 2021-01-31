; Draw a line of hearts
; a = length, x,y = x/y screen coords
.proc draw_vertical_line
  ; Vars for draw_line
  COLOR = r0
  ; Temp Vars
  LENGTH = r11
  ; Constants
  CHAR = $42

  draw_vertical_line:
    sta LENGTH
    txa
    sta VERA_addr_low
    sty VERA_addr_med
  @loop:
    ;a = x, y = y
    txa
    jsr graphics::drawing::goto_xy
    lda #CHAR
    sta VERA_data0 ; Write chracter
    lda COLOR
    sta VERA_data0 ; Write color
    iny
    cpy LENGTH
    bne @loop
    rts
.endproc
