; Graphic routines

.scope graphics
  ; Vera specific routines
  .scope vera
    .include "library/graphics/vera/clear_vram.asm"
    .include "library/graphics/vera/load_palette16.asm"
  .endscope

  ; Kernal specific routines (as in not vera)
  ; will likely not be used after a certain point
  .scope kernal
    ;.include "library/graphics/kernal/clearscreen.asm"
    .include "library/graphics/kernal/printhex.asm"
  .endscope

  ; Drawing rountines
  .scope drawing
    .include "library/graphics/drawing/goto_xy.asm"
    .include "library/graphics/drawing/print_hex.asm"
    .include "library/graphics/drawing/print_char.asm"
    .include "library/graphics/drawing/draw_characters.asm"
    .include "library/graphics/drawing/draw_horizontal_line.asm"
    .include "library/graphics/drawing/draw_vertical_line.asm"
    .include "library/graphics/drawing/draw_solid_box.asm"
    .include "library/graphics/drawing/draw_rounded_box.asm"
    .include "library/graphics/drawing/load_screen.asm"
    .include "library/graphics/drawing/print_string.asm"
    .include "library/graphics/drawing/cursor.asm"
    .include "library/graphics/drawing/chars_to_number.asm"
  .endscope

.endscope
