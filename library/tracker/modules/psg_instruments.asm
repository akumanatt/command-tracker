.scope psg_instruments
.proc init
init:
  jsr ui::draw_frame
  ;jsr ui::draw_psg_instruments_frame
  lda #PSG_INSTRUMENTS_MODULE
  sta current_module
  stz key_pressed
.endproc

.proc keyboard_loop
keyboard_loop:
  jmp main_application_loop
.endproc

.endscope
