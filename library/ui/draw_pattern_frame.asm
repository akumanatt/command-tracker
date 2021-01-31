; Draws the lower UI element for the pattern view
.proc draw_pattern_frame
  ; Constants
  DISPLAY_END_X = $4F
  DISPLAY_END_Y = $3B

  ; Plus
  DOWN_TEE = $72
  UP_TEE = $71
  LEFT_TEE = $73
  RIGHT_TEE = $6B
  PLUS_TEE = $5B

  START_X = $01
  STOP_X = DISPLAY_END_X - 1
  CHANNEL_TOP_Y = $07
  CHANNEL_BOTTOM_Y = $09
  ;FIRST_CHANNEL_X = $03
  FIRST_CHANNEL_X = $03
  ; Distance between the lines for the channels
  CHANNEL_WIDTH = $0C

  NUM_CHANNEL_COLUMNS = $06

  ;SECOND_CHANNEL_X = $0F
  ;THIRD_CHANNEL_X = $1B
  ;FOURTH_CHANNEL_X = $27
  ;FIFTH_CHANNEL_X = $33
  ;SIXTH_CHANNEL_X = $3F

  PATTERN_LINES_START_Y = $08
  ; Vars
  COLOR = r0
  ; Temp
  COUNT = r15

draw_pattern_frame:

@draw_empty_box:
  ; x-pos
  lda #$01
  sta r0
  ; y-pos
  lda #CHANNEL_BOTTOM_Y + 1
  sta r1
  lda #DISPLAY_END_X - 1
  sta r2
  lda #(DISPLAY_END_Y - CHANNEL_BOTTOM_Y - 1)
  sta r3
  stz r4  ; COLOR (but black in this case)
  jsr graphics::drawing::draw_solid_box

@set_frame_color:
  lda #FRAME_COLOR
  sta COLOR

@horizontal_channel_lines:
  lda #STOP_X
  ldx #START_X
  ldy #CHANNEL_TOP_Y
  jsr graphics::drawing::draw_horizontal_line
  lda #STOP_X
  ldx #START_X
  ldy #CHANNEL_BOTTOM_Y
  jsr graphics::drawing::draw_horizontal_line

@draw_channel_separators:
  ldx #FIRST_CHANNEL_X
  ldy #NUM_CHANNEL_COLUMNS + 1

@separator_loop:
  phx
  phy
  lda #DISPLAY_END_Y
  ldy #PATTERN_LINES_START_Y

  jsr graphics::drawing::draw_vertical_line
  ply
  plx
  txa
  clc
  adc #CHANNEL_WIDTH
  tax
  dey
  bne @separator_loop

@draw_connectors:
  lda #FIRST_CHANNEL_X
  ldx #NUM_CHANNEL_COLUMNS + 1
@draw_connectors_loop:
  ldy #CHANNEL_TOP_Y
  pha
  jsr graphics::drawing::goto_xy
  print_char_with_color #DOWN_TEE, COLOR
  pla

  ldy #CHANNEL_BOTTOM_Y
  pha
  jsr graphics::drawing::goto_xy
  print_char_with_color #PLUS_TEE, COLOR
  pla

  ldy #DISPLAY_END_Y
  pha
  jsr graphics::drawing::goto_xy
  print_char_with_color #UP_TEE, COLOR
  pla

  clc
  adc #CHANNEL_WIDTH
  dex
  bne @draw_connectors_loop

  rts
.endproc
