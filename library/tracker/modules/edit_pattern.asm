; Edit pattern
.proc edit_pattern

;pattern_being_edited

edit_pattern:
  ;jsr draw_solid_box
  jsr ui::print_pattern
  jsr ui::draw_pattern_frame

@edit_pattern_loop:
  cli
  wai
@check_keyboard:
  jsr GETIN  ;keyboard
  cmp #F1
  beq @help_module
  cmp #F5
  beq @play_song_module
  cmp #F8
  beq @stop_song
  cmp #F11
  beq @order_list_module
  jmp @edit_pattern_loop

@help_module:
  jmp main
@play_song_module:
  jmp tracker::modules::play_song
@stop_song:
  jsr tracker::stop_song
  jmp @edit_pattern_loop
@order_list_module:
  jmp tracker::modules::orders


  jmp @edit_pattern_loop

.endproc
