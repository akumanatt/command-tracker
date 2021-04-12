; The main application which is responsible for calling different modules

.include "includes.inc"

; Initial run once stuff
start:
  jsr setup
  jsr graphics::vera::clear_vram
  jsr ui::draw_frame
  jsr ui::print_song_info
  jsr ui::print_speed

  ; Default to help module
  jmp tracker::modules::help::init

; Main module
main:
main_application_loop:
  cli
  wai
check_keyboard:
  jsr GETIN  ;keyboard
  ; If zero, loop as there is nothing to do
  beq main_application_loop
  sta key_pressed

; Check global keys that interrupt function (like change modules)
check_global_keys:
@f1_key:
  cmp #F1
  bne @f2_key
  ldx #HELP_MODULE
  jmp init_jump_table

@f2_key:
  cmp #F2
  bne @f5_key
  ldx #EDIT_PATTERN_MODULE
  jmp init_jump_table

@f5_key:
  cmp #F5
  bne @f8_key
  ldx #PLAY_SONG_MODULE
  jmp init_jump_table

@f8_key:
  cmp #F8
  bne @f10_key
  jsr tracker::stop_song
  jmp main_application_loop

@f10_key:
  cmp #F10
  bne @f11_key
  ldx #SAVE_MODULE
  jmp init_jump_table

@f11_key:
  cmp #F11
  bne @module_loop
  ldx #ORDERS_MODULE
  jmp init_jump_table

@module_loop:
; If no global key was pressed, we pass control to the current module's loop
  jmp loop_jump_table

init_jump_table:
  lda init_jump_table_low,x
  sta r15
  lda init_jump_table_high,x
  sta r15+1
  jmp (r15)

loop_jump_table:
  ldx current_module
  lda loop_jump_table_low,x
  sta r15
  lda loop_jump_table_high,x
  sta r15+1
  jmp (r15)


.include "data.inc"
