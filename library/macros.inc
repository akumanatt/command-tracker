.macro  gotocoords  xpos, ypos
    ldx   #xpos
    ldy   #ypos
    clc
    jsr   PLOT
.endmacro

.macro print_string msg
  lda #<msg
  sta STRING_POINTER
  lda #>msg
  sta STRING_POINTER+1
  jsr print_string
.endmacro
