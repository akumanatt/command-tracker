; How to save the order list:
; - Track cursor position in 0,1
; - WHen moving left or right, check 0,1
; - If a char was typed at pos 1, read line. If it's a valid number, store it
; - The cursor should be relative to the order list (I tink?)
;   + That is, drawing the order list should be decoupled. We place the
;     cursor where it needs to go.
;   + This is because arrow up/down vs pg up/dn will be different anyway

; pg up/dn, we redraw the entire list, skipping by the number of rows
; displayed AND update the cursor (most of the time the cursor won't
; move unless we're close to the end)

; For arrow up/dn, if we're at the bottom or top of the current list,
; we redraw the list by one (if there is more orders in the desired direction)
; We don't need to move the cursor, but do need to update its order list
; position

; SO in other words, the cursor is always matched to the order number
; and not the position on the screen.


.include "includes.inc"

KEY_UP = $91
KEY_DOWN = $11
KEY_LEFT = $9D
KEY_RIGHT = $1D
ENTER = $0D

; Constrain movement of the cursor to only the order list
CURSOR_MIN_X = $24
CURSOR_MAX_X = $25
CURSOR_MIN_Y = $0A
CURSOR_MAX_Y = $3A

; Place to start the orders list
ORDER_LIST_X = $20
ORDER_LIST_Y = $0A
; How many characters over the patterns are
ORDER_LIST_OFFSET = $08
NUM_ORDERS_TO_SHOW = $30


; Put this elsewhere
; Where to start the order list display from
; (such as if we're scrolled further down)
order_list_start: .byte $00

; Where the cursor is in the order list
order_list_position: .byte $00

; Which column the cursor is in (there are only 2)
ordrer_list_column: .byte $00

start:
  jsr setup
  jsr ui::draw_frame

  lda #$00
  sta r1
  jsr ui::draw_orders_frame

cursor_start_position:
  lda #$00
  sta r0
  lda #CURSOR_MIN_X
  sta cursor_x
  lda #CURSOR_MIN_Y
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

; On up/down check if we are at the end of the entire list
; and if we are at the end of the view.
; If at the end of the view, will need to redraw the list
; Also update where in the order list we are.

@cursor_up:
  lda cursor_y
  cmp #CURSOR_MIN_Y
  beq main_loop
  jsr ui::cursor_up
  jmp main_loop
@cursor_down:
  lda cursor_y
  cmp #CURSOR_MAX_Y
  beq main_loop
  jsr ui::cursor_down
  jmp main_loop

; Track the column position of the cursor here as well.
; Needed for further down.
@cursor_left:
  lda cursor_x
  cmp #CURSOR_MIN_X
  beq main_loop
  jsr ui::cursor_left
  jmp main_loop
@cursor_right:
  lda cursor_x
  cmp #CURSOR_MAX_X
  beq main_loop
  jsr ui::cursor_right
  jmp main_loop

; Print the # the user typed. If ordrer_list_column is 1, we are in the
; second column, so we need to see if it's a valid pattern number and, if so,
; we need to call a routine to update the order list array.
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

  ; If we printed a character, and we're not at the last column
  ; move to the right
  lda cursor_x
  cmp #CURSOR_MAX_X
  beq @print_end
  jsr ui::cursor_right
@print_end:
  jmp main_loop

; See above instructions. This will have to be rewritten.
; Save the order the cursor is at, after the user puts in the
; two characters.
;
; - Get the cursor X/Y
; - Determine the offset of the cursor in the list
;   as this gives the line of the order and pattern number
; - Save pattern at the index
;

@save_order:


; Saves all the visible orders. However, this doesn't make a lot
; of sense UI wise. Better to save an order when the user inputs it?
@save_orders:
  lda #$20  ; skip over colors
  sta VERA_addr_high
  ; Y-pos
  ldy #ORDER_LIST_Y
  sty VERA_addr_med
  ; X-pos (shfiting due to colors, then adding offset to actual user number)
  lda #ORDER_LIST_X
  asl
  clc
  adc #ORDER_LIST_OFFSET
  sta VERA_addr_low
  ; The first order that starts the list on the screen
  ldx order_list_start

@save_orders_loop:
  ; y pos
  sty VERA_addr_med
  ; x pos (constant as we're just going down the list)
  ;ldx
  stx VERA_addr_low   ; x

  ; First character
  lda VERA_data0
  sta r0

  ; Second character
  lda VERA_data0
  sta r1
  jsr graphics::drawing::chars_to_number
  ;jsr graphics::drawing::print_hex
  jsr graphics::kernal::printhex
  iny
  cpy #NUM_ORDERS_TO_SHOW
  bne @save_orders_loop
@save_orders_end:
  lda #$00  ; Revert skip
  sta VERA_addr_high
  jmp main_loop


;.include "pattern.inc"
.include "data.inc"
