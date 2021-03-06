; Graphic routines


.scope ui
  ; Top Header Labels

  command_tracker_string: .byte "command tracker v0.000",0
  song_label: .byte "song:",0
  composer_label: .byte "by  :",0
  speed_label: .byte "spd:",0
  pattern_label: .byte "pat:",0
  order_label: .byte "ord:",0
  row_label: .byte "row:",0
  more_channels_label: .byte ">>>",0
  row_header: .byte "##",0

  ; Order List Page Labels:
  order_list_label: .byte "orders:",0
  goto_pattern_message: .byte "press g to edit pattern",0

  verasound_channel_header: .byte "vs ",0
  ym_channel_header: .byte "ym ",0
  pcm_channel_header: .byte "pcm ",0

  ; includes
  .include "library/ui/draw_frame.asm"
  .include "library/ui/clear_lower_frame.asm"
  .include "library/ui/draw_pattern_frame.asm"
  .include "library/ui/draw_orders_frame.asm"
  .include "library/ui/draw_help_frame.asm"
  .include "library/ui/draw_save_frame.asm"
  .include "library/ui/draw_playsong_frame.asm"
  .include "library/ui/print_song_info.asm"
  .include "library/ui/print_current_pattern_number.asm"
  .include "library/ui/print_number_of_orders.asm"
  .include "library/ui/print_current_order.asm"
  .include "library/ui/print_speed.asm"
  .include "library/ui/print_row_count.asm"
  .include "library/ui/print_pattern.asm"
  ;.include "library/ui/print_playing_pattern.asm"
  ;.include "library/ui/print_edit_pattern.asm"
  .include "library/ui/print_note.asm"
  .include "library/ui/scroll_pattern.asm"

  .include "library/ui/move_cursor.asm"



.endscope
