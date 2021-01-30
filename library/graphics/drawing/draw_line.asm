; Draw a line of hearts
; a = length, x,y = x/y screen coords
.proc draw_line
  ; Vars for draw_line
  HEART = $53
  LENGTH = r11
  COLOR = r4
  draw_line:
    sta LENGTH
    txa
    asl
    sta VERA_addr_low
    sty VERA_addr_med
    ldx 0
  @loop:
    lda #HEART
    sta VERA_data0 ; Write chracter
    lda #COLOR
    sta VERA_data0 ; Write color
    inx
    cpx LENGTH
    bne @loop
    rts
.endproc
