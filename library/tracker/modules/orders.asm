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

.proc orders

; Constrain movement of the cursor to only the order list
CURSOR_START_X = $24
;CURSOR_START_Y = $25
CURSOR_START_Y = $0A

; How many columns we have (2)
ORDERS_MIN_COLUMN = $00
ORDERS_MAX_COLUMN = $01

start:
  ;jsr setup
  ;jsr ui::draw_frame

  lda #$00
  sta r1
  jsr ui::draw_orders_frame

cursor_start_position:
  lda #$00
  sta cursor_layer
  sta order_list_position
  sta order_list_column
  lda #CURSOR_START_X
  sta cursor_x
  lda #CURSOR_START_Y
  sta cursor_y
  jsr graphics::drawing::cursor_plot

@main_orders_loop:
  wai
@check_keyboard:
  ; Returns 0 is no input
  jsr GETIN  ;keyboard
  cmp #$00
  beq @main_orders_loop
  cmp #F1
  beq @help_module
  cmp #F2
  beq @edit_pattern_module
  cmp #F8
  beq @stop_song
  cmp #F5
  beq @play_song_module

  cmp #KEY_UP
  beq @cursor_up
  cmp #KEY_DOWN
  beq @cursor_down
  cmp #KEY_LEFT
  beq @cursor_left
  cmp #KEY_RIGHT
  beq @cursor_right
  cmp #ENTER
  beq start
  cmp #$30
  bpl @print_alphanumeric
  jmp @main_orders_loop

@help_module:
  jmp main
@edit_pattern_module:
  jmp tracker::modules::edit_pattern
@stop_song:
  jsr tracker::stop_song
  jmp @main_orders_loop
@play_song_module:
  jmp tracker::modules::play_song



; On up/down check if we are at the end of the entire list
; and if we are at the end of the view.
; If at the end of the view, will need to redraw the list
; Also update where in the order list we are.

@cursor_up:
  lda order_list_position
  beq @main_orders_loop
  jsr ui::cursor_up
  dec order_list_position
  jmp @main_orders_loop
@cursor_down:
  lda order_list_position
  cmp #$FF
  beq @main_orders_loop
  jsr ui::cursor_down
  inc order_list_position
  jmp @main_orders_loop

; Track the column position of the cursor here as well.
; Needed for further down.
@cursor_left:
  lda order_list_column
  beq @main_orders_loop
  jsr ui::cursor_left
  dec order_list_column
  jmp @main_orders_loop
@cursor_right:
  lda order_list_column
  cmp #ORDERS_MAX_COLUMN
  beq @main_orders_loop
  jsr ui::cursor_right
  inc order_list_column
  jmp @main_orders_loop

; Print the # the user typed. If ordrer_list_column is 1, we are in the
; second column, so we need to see if it's a valid pattern number and, if so,
; we need to call a routine to update the order list array.
@print_alphanumeric:
  pha
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  pla
  cmp #PETSCII_AT
  bmi @print_numeric
  cmp #PETSCII_G
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
  lda order_list_column
  cmp #ORDERS_MAX_COLUMN
  ;beq @save_order
  beq @save_order
  jsr ui::cursor_right
  inc order_list_column
  jmp @print_end
; If we're already on the last column,
; check to see if we should save the order
; Move back to the first colum so we can read the full value
@save_order:
  jsr ui::cursor_left
  dec order_list_column
  ;jmp @print_end works to this point


  ; Y-pos
  ldy cursor_y
  sty VERA_addr_med
  ; X-pos of first digit
  lda cursor_x
  asl ; because 2 bytes per X pos (second being color)
  sta VERA_addr_low

  ; Since we're already on the second digit, we can find the first
  lda #$20  ; skip over colors
  sta VERA_addr_high

  ; First character
  lda VERA_data0
  jsr check_for_high_screencode
  sta r0

  ; Second character
  lda VERA_data0
  jsr check_for_high_screencode
  sta r1

  ; Disable stride
  lda #00  ; skip over colors
  sta VERA_addr_high

 jsr graphics::drawing::chars_to_number

 ; Finally save the order
 ldy order_list_position
 sta order_list,y

@print_end:
  jmp @main_orders_loop

; I don't know why it does this but it's using the high characters
; but only for the letters?
; See http://sta.c64.org/cbm64scr.html
check_for_high_screencode:
  cmp #$80
  bpl @unreverse
  jmp @unreverse_end
@unreverse:
  sbc #$80
@unreverse_end:
  rts

.endproc
