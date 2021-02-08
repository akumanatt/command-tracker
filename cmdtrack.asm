; The main application which is responsible for calling different modules

.include "includes.inc"

; Initial run once stuff
start:
  jsr setup
  jsr ui::draw_frame

; Main module
main:
  jsr ui::draw_help_frame

main_application_loop:
  cli
  wai
check_keyboard:
  jsr GETIN  ;keyboard
  ;cmp #F1
  ;beq
  cmp #F2
  beq @edit_pattern_module
  cmp #F5
  beq @play_song_module
  cmp #F8
  beq @stop_song
  cmp #F11
  beq @order_list_module
  jmp main_application_loop

; Jump to order list module
@edit_pattern_module:
  jsr tracker::stop_song
  jmp tracker::modules::edit_pattern

@play_song_module:
  jmp tracker::modules::play_song

@stop_song:
  jsr tracker::stop_song
  jmp main_application_loop

@order_list_module:
  jmp tracker::modules::orders



.include "data.inc"
