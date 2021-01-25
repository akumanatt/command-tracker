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
