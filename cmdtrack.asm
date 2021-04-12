; The main application which is responsible for calling different modules

.include "includes.inc"

; Initial run once stuff
start:
  jsr setup
  jsr graphics::vera::clear_vram
  ; Default to help module
  jmp tracker::modules::help::init

; Main module
main:
main_application_loop:
  cli
  wai
; Check for input from the keyboard, and do something if
; a key was pressed (return value is something other than 0)
check_keyboard:
  jsr GETIN  ;keyboard
  beq main_application_loop
  sta key_pressed
; Check global keys - these keys do the same thing for all modules
check_global_keys:
; Help menu
@f1_key:
  cmp #F1
  bne @f2_key
  ldx #HELP_MODULE
  jmp init_jump_table
; Edit Pattern Module
@f2_key:
  cmp #F2
  bne @f5_key
  ldx #EDIT_PATTERN_MODULE
  jmp init_jump_table
; Play full song
@f5_key:
  cmp #F5
  bne @f8_key
  ldx #PLAY_SONG_MODULE
  jmp init_jump_table
; Stop song (doesn't change module)
@f8_key:
  cmp #F8
  bne @f10_key
  jsr tracker::stop_song
  jmp main_application_loop
; Load/Save
@f10_key:
  cmp #F10
  bne @f11_key
  ldx #SAVE_MODULE
  jmp init_jump_table
; Orders
@f11_key:
  cmp #F11
  bne @module_loop
  ldx #ORDERS_MODULE
  jmp init_jump_table

; If no global key was pressed, we pass control to the current module's loop
@module_loop:
  jmp loop_jump_table

; When we change modules, we need to run some init code, but only once for
; each module. Thereafter we just need to loop for keyboard
; which is handled in the loop_jump_table
init_jump_table:
  lda init_jump_table_low,x
  sta r15
  lda init_jump_table_high,x
  sta r15+1
  jmp (r15)

; Jump to the loop of the current module
loop_jump_table:
  ldx current_module
  lda loop_jump_table_low,x
  sta r15
  lda loop_jump_table_high,x
  sta r15+1
  jmp (r15)


.include "data.inc"
