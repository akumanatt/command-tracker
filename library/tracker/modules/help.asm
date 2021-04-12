.scope help
.proc init
init:
  jsr ui::draw_frame
  print_string_macro help_text, #$05, #$0E, #TITLE_COLORS
  lda #HELP_MODULE
  sta current_module
  stz key_pressed
.endproc

.proc keyboard_loop
keyboard_loop:
  jmp main_application_loop
.endproc

help_text:
  .byte "f1  : help", SCREENCODE_RETURN
  .byte "f2  : edit pattern", SCREENCODE_RETURN
  .byte "f3  : psg instruments", SCREENCODE_RETURN
  .byte "f4  : fm instruments", SCREENCODE_RETURN
  .byte "f5  : play song", SCREENCODE_RETURN
  .byte "f6  : play pattern (in edit pattern only)", SCREENCODE_RETURN
  .byte "f7  : start song at row (in edit pattern only)", SCREENCODE_RETURN
  .byte "f8  : stop", SCREENCODE_RETURN
  .byte "f10 : load/save", SCREENCODE_RETURN
  .byte "f11 : orders", SCREENCODE_RETURN
  .byte SCREENCODE_RETURN, SCREENCODE_RETURN, SCREENCODE_RETURN
  .byte SCREENCODE_RETURN, SCREENCODE_RETURN, SCREENCODE_RETURN
  .byte "psg engine powered by concerto"
  .byte 0

.endscope
