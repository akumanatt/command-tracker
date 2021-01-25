.macro  gotocoords  xpos, ypos
    phx
    phy
    ldx   #xpos
    ldy   #ypos
    clc
    jsr   PLOT
    ply
    plx
.endmacro

.macro print_string msg
  lda #<msg
  sta STRING_POINTER
  lda #>msg
  sta STRING_POINTER+1
  jsr print_string
.endmacro

.macro vera_stride stride
  pha
  lda VERA_addr_high
  and #%00011111
  ora stride
  sta VERA_addr_high
  pla
.endmacro

.macro set_text_color color
  lda color
  sta r0
.endmacro
