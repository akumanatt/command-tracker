; Draws the lower UI element for the pattern view

  CHANNEL_START = r11
  CHANNEL_STOP = r12
.proc draw_pattern_frame
  ; Constants
  ; Characters
  DOWN_TEE = $72
  UP_TEE = $71
  LEFT_TEE = $73
  RIGHT_TEE = $6B
  PLUS_TEE = $5B

  ; Locations
  START_X = $01
  STOP_X = DISPLAY_END_X - 1
  CHANNEL_TOP_Y = $07
  CHANNEL_HEADER = $08
  CHANNEL_BOTTOM_Y = $09
  FIRST_CHANNEL_X = $03
  ; Distance between the lines for the channels
  CHANNEL_WIDTH = $0C

  NUM_CHANNEL_COLUMNS = $06
  PATTERN_LINES_START_Y = $08
  ; Vars
  COLOR = r0
  ; Temp
  COUNT = r15

draw_pattern_frame:
  jsr ui::clear_lower_frame

@draw_labels:

  print_string_macro more_channels_label, #MORE_CHANNELS_LABEL_X, #MORE_CHANNELS_LABEL_Y, #TITLE_COLORS
  print_string_macro row_header, #ROW_HEADER_X, #ROW_HEADER_Y, #TITLE_COLORS

  ldx first_channel_in_pattern_view
  lda #FIRST_CHANNEL_X + 1
  sta CHANNEL_START

  lda first_channel_in_pattern_view
  clc
  adc NUM_CHANNEL_COLUMNS
  sbc #$01
  sta CHANNEL_STOP

@channel_labels_loop:
  print_string_macro verasound_channel_header, CHANNEL_START, #CHANNEL_HEADER, #VERA_CHANNEL_COLOR
  lda #VERA_CHANNEL_COLOR
  sta r0
  phx
  txa
  jsr graphics::drawing::print_hex

  lda CHANNEL_START
  clc
  adc #CHANNEL_WIDTH
  sta CHANNEL_START
  plx
  inx

  cpx CHANNEL_STOP
  bne @channel_labels_loop

@draw_empty_lower_box:
  ; x-pos
  lda #$01
  sta r0
  ; y-pos
  lda #CHANNEL_BOTTOM_Y + 1
  sta r1
  lda #DISPLAY_END_X - 5
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

; The sides of the channel lines where they touch the main frame
@horizontal_channel_connectors:
  lda #$00
  ldy #CHANNEL_TOP_Y
  jsr graphics::drawing::goto_xy
  print_char_with_color #RIGHT_TEE, COLOR

  lda #$00
  ldy #CHANNEL_BOTTOM_Y
  jsr graphics::drawing::goto_xy
  print_char_with_color #RIGHT_TEE, COLOR

  lda #DISPLAY_END_X
  ldy #CHANNEL_TOP_Y
  jsr graphics::drawing::goto_xy
  print_char_with_color #LEFT_TEE, COLOR

  lda #DISPLAY_END_X
  ldy #CHANNEL_BOTTOM_Y
  jsr graphics::drawing::goto_xy
  print_char_with_color #LEFT_TEE, COLOR

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

; If the song is playing, be sure to draw the playback lines
; FIX ME TO BE BETTER
@draw_playback_marker:
  lda #$01
  sta r0
  lda STATE
  beq @end
  lda #$4F
  ldx #$00
  ldy #$1F
  jsr graphics::drawing::draw_horizontal_line
  lda #$4F
  ldx #$00
  ldy #$21
  jsr graphics::drawing::draw_horizontal_line

@end:
  rts
.endproc
