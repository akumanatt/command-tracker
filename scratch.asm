.include "includes.inc"

KEY_UP = $91
KEY_DOWN = $11
KEY_LEFT = $9D
KEY_RIGHT = $1D
ENTER = $0D
; Put this elsewhere
; The position in the order list we are in
; (between 0 and FF)
; Should help for knowing if we need to scroll
order_index: .byte $00

start:
  jsr setup
  jsr ui::draw_frame
  jsr ui::draw_orders_frame

  lda #$24
  sta cursor_x
  lda #$0A
  sta cursor_y
  jsr graphics::drawing::cursor_plot

main_loop:
  wai
check_keyboard:
  ; Returns 0 is no input
  jsr GETIN  ;keyboard
  cmp #$00
  beq main_loop

  cmp #KEY_UP
  beq @cursor_up
  cmp #KEY_DOWN
  beq @cursor_down
  cmp #KEY_LEFT
  beq @cursor_left
  cmp #KEY_RIGHT
  beq @cursor_right
  cmp #ENTER
  beq @save_orders
  cmp #$30
  bpl @print_alphanumeric
  jmp main_loop

@cursor_up:
  jsr ui::cursor_up
  dec order_index
  jmp main_loop
@cursor_down:
  jsr ui::cursor_down
  inc order_index
  jmp main_loop
@cursor_left:
  jsr ui::cursor_left
  jmp main_loop
@cursor_right:
  jsr ui::cursor_right
  jmp main_loop

@print_alphanumeric:
  pha
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  pla
  cmp #$40
  bmi @print_numeric
  cmp #$47
  bpl @print_end
@print_alpha:
  clc
  adc #$40  ; add 40 to get to the letter screencodes, then fall through
@print_numeric:
  pha
  sta VERA_data0
  inc VERA_addr_low
  lda #EDITABLE_TEXT_COLORS
  sta VERA_data0
  ; If we printed a character, move to the right
  jsr ui::cursor_right
@print_end:
  jmp main_loop

@save_orders:
  jsr graphics::kernal::printhex
  jmp main_loop


;.include "pattern.inc"
.include "data.inc"
