; The main application which is responsible for calling different modules

.include "includes.inc"

; Initial run once stuff
start:
  jsr setup
  jsr graphics::vera::clear_vram
  jsr ui::draw_frame
  jsr ui::print_song_info
  jsr ui::print_speed

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
@f2_key:
  cmp #F2
  bne @f5_key
  ldx #EDIT_PATTERN_MODULE
  jmp @jump_table

@f5_key:
  cmp #F5
  bne @f10_key
  ldx #PLAY_SONG_MODULE
  jmp @jump_table

@f10_key:
  cmp #F10
  bne @f11_key
  ldx #SAVE_SONG_MODULE
  jmp @jump_table

@f11_key:
  cmp #F11
  bne main_application_loop
  ldx #ORDERS_MODULE

@jump_table:
  lda jump_table_low,x
  sta r15
  lda jump_table_high,x
  sta r15+1
  jmp (r15)


.include "data.inc"
