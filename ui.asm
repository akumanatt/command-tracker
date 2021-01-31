; Graphic routines

.scope ui
  ; data
  command_tracker_string: .byte "command tracker v0.000",0
  song_label: .byte "song:",0
  composer_label: .byte "by  :",0
  speed_label: .byte "spd:",0
  pattern_label: .byte "pat:",0
  order_label: .byte "ord:  /",0
  row_label: .byte "row:",0

  ; includes
  .include "library/ui/draw_frame.asm"
  .include "library/ui/print_song_info.asm"
  .include "library/ui/print_current_pattern_number.asm"
  .include "library/ui/print_number_of_orders.asm"
  .include "library/ui/print_current_order.asm"
  .include "library/ui/print_speed.asm"
  .include "library/ui/print_row_count.asm"
  .include "library/ui/print_pattern.asm"
  .include "library/ui/print_note.asm"
  .include "library/ui/scroll_pattern.asm"



.endscope
