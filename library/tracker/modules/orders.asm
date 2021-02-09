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
  ; Relative position we are in the order list on screen
  ORDER_LIST_POSITION = r14

; Constrain movement of the cursor to only the order list
CURSOR_START_X = $24
CURSOR_START_Y = $0A
CURSOR_STOP_Y = $2F

; How many columns we have (2)
ORDERS_MIN_COLUMN = $00
ORDERS_MAX_COLUMN = $01

start:
  lda #$10
  sta VERA_addr_high ; Set primary address bank to 0, stride to 1
  jsr ui::clear_lower_frame
  lda #$00
  sta r1
  sta order_list_start
  sta ORDER_LIST_POSITION
  sta order_list_column
  jsr ui::draw_orders_frame

@cursor_start_position:
  lda #$00
  sta cursor_layer

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
  beq @edit_pattern_jump
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
  cmp #PETSCII_G
  beq @edit_pattern_jump
  cmp #$30
  bpl @print_alphanumeric
  jmp @main_orders_loop

@help_module:
  jmp main
@stop_song:
  jsr tracker::stop_song
  jmp @main_orders_loop
@play_song_module:
  jmp tracker::modules::play_song

@edit_pattern_jump:
  jmp @edit_pattern

; On up/down check if we are at the end of the entire list
; and if we are at the end of the view.
; If at the end of the view, will need to redraw the list
; Also update where in the order list we are.

@cursor_up:
  lda ORDER_LIST_POSITION
  beq @cursor_scroll_up_jump
  jsr ui::cursor_up
  dec ORDER_LIST_POSITION
  jmp @main_orders_loop
@cursor_scroll_up_jump:
  jmp @scroll_orders_up

@cursor_down:
  lda ORDER_LIST_POSITION
  cmp #CURSOR_STOP_Y
  beq @cursor_scroll_down_jump
  jsr ui::cursor_down
  inc ORDER_LIST_POSITION
  jmp @main_orders_loop
  ; If we're at the bottom of the screen, scroll the orders
@cursor_scroll_down_jump:
  jmp @scroll_orders_down

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
  sbc #$3F  ; add 40 to get to the letter screencodes, then fall through
@print_numeric:
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
  sta r0

  ; Second character
  lda VERA_data0
  sta r1

  ; Disable stride
  lda #00
  sta VERA_addr_high

 jsr graphics::drawing::chars_to_number

 ; Finally save the order
 ldy ORDER_LIST_POSITION
 sta order_list,y

@print_end:
  jmp @main_orders_loop

; If we're at the top of the screen, but we have more
; orders, scroll the order list
@scroll_orders_up:
  ; Commented out because now it just loops around that's kinda cool
  ; ORDER_LIST_POSITION already in a
  ; If we're at the min order, no more scrolling for you!
  ; cmp #$00
  ; beq @main_orders_loop_jump
  dec order_list_start
  jsr ui::draw_orders_frame
  jsr graphics::drawing::cursor_plot
  jmp @main_orders_loop

; If we're at the bottom of the screen, but we have more
; orders, scroll the order list
@scroll_orders_down:
  ; Commented out because now it just loops around that's kinda cool
  ; ORDER_LIST_POSITION already in a
  ; If we're at the max order, no more scrolling for you!
  ;cmp #MAX_ORDERS
  ;beq @main_orders_loop_jump
  inc order_list_start
  jsr ui::draw_orders_frame
  jsr graphics::drawing::cursor_plot
  jmp @main_orders_loop

@main_orders_loop_jump:
  jmp @main_orders_loop

; Edit pattern specified at cursor
@edit_pattern:
  ; If we're on the second column, move over one
  lda order_list_column
  beq @get_pattern_at_cursor
  jsr ui::cursor_left
  dec order_list_column
@get_pattern_at_cursor:
  lda #$20  ; skip over colors
  sta VERA_addr_high

  ldy cursor_y
  sty VERA_addr_med
  ; X-pos of first digit
  lda cursor_x
  asl ; because 2 bytes per X pos (second being color)
  sta VERA_addr_low

  ; First character
  lda VERA_data0
  sta r0

  ; Second character
  lda VERA_data0
  sta r1

  jsr graphics::drawing::chars_to_number
  sta PATTERN_NUMBER
  jsr tracker::stop_song
  jmp tracker::modules::edit_pattern

.endproc
