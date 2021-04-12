.scope help
.proc init
init:
  jsr ui::draw_help_frame
  lda #HELP_MODULE
  sta current_module
  stz key_pressed
.endproc

.proc keyboard_loop
keyboard_loop:
  jmp main_application_loop
.endproc

.endscope
