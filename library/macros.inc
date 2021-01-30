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

.macro set_background_foregound_text_color background_color, foreground_color
  pha
  lda foreground_color
  sta r0
  lda background_color
  sta r1
  jsr math::set_top_nibble
  lda r2
  sta r0
  pla
.endmacro
