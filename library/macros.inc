.macro print_string_macro msg, xpos, ypos, color
  lda #<msg
  sta r0
  lda #>msg
  sta r0+1
  lda xpos
  sta r1
  lda ypos
  sta r2
  lda color
  sta r3
  jsr graphics::drawing::print_string

.endmacro

.macro vera_stride stride
  pha
  lda VERA_addr_high
  and #%00001111
  ora stride
  sta VERA_addr_high
  pla
.endmacro

.macro set_text_color color
  lda color
  sta r0
.endmacro

.macro print_char_with_color char, color
  lda char
  sta VERA_data0
  lda color
  sta VERA_data0
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

.macro global_keyboard_shortcuts


.endmacro
