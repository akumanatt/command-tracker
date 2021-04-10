; Edit pattern
.proc edit_pattern

; Constants
NOTE          = $00
INSTRUMENT    = $01
VOLULME       = $02
EFFECT        = $03
EFFECT_VALUE  = $04
SCREEN_ROW_MAX = $30
NUM_CHANNELS_VISIBLE = $06 ; Number of channels to see at once

CURSOR_X_START = $03  ; We need to skip past the row numbers and things
; What cursor position to start when moving past last screen channel
; This puts the cursor at the beginning of screen channel 6
CURSOR_X_START_OF_LAST_CHNNAEL = $3F
; If col pos is 0, note
; If 3 inst
; If 5 vol
; 7 eff
; 9 eff val
; 10 end of that CHANNEL_NUMBER (skip 2)
NOTE_COLUMN_POSITIION = $00
INSTRUMENT_COLUMN_POSITIION = $03
VOLUMNE_COLUMN_POSITIION = $05
EFFECT_COLUMN_POSITIION = $07
EFFECT_VALUE_COLUMN_POSITIION = $09
LAST_COLUMN_POSITION = $0A

; Vars
COLOR           = r0
; Screen row pos (may differ from pattern when scrolling)
;COLUMN_POS      = r6       ; Note, Inst, Vol, Eff, Effect Value
;PITCH_TEMP      = r7
;SCREEN_ROW      = r9
;SCREEN_CHANNEL  = r9 + 1

COLUMN_POS      = TMP1       ; Note, Inst, Vol, Eff, Effect Value
PITCH_TEMP      = TMP2
SCREEN_ROW      = TMP3
SCREEN_CHANNEL  = TMP4


; Initial run once stuff
edit_pattern:
  lda PATTERN_NUMBER
  sta RAM_BANK
  stz START_CHANNEL
  jsr ui::clear_lower_frame
  jsr ui::draw_pattern_frame
  jsr ui::print_pattern

  stz CHANNEL_NUMBER
  stz SCREEN_CHANNEL
  stz COLUMN_POS
  stz ROW_NUMBER
  jsr ui::print_current_pattern_number
  jsr ui::print_row_number

  lda #CURSOR_X_START
  sta cursor_x
  lda #$FF
  sta VERA_L0_hscroll_h
  lda #$F8
  sta VERA_L0_hscroll_l
  jsr reset_scroll_position

edit_pattern_loop:
  wai
  jsr GETIN  ;keyboard
  cmp #$00
  beq edit_pattern_loop
  cmp #F1
  beq @help_module
  cmp #F2
  beq edit_pattern
  cmp #F5
  beq @play_song_module
  cmp #F6
  beq @play_pattern_jump
  cmp #F7
  beq @play_song_at_row_jump
  cmp #F8
  beq @stop_jump
  cmp #F10
  beq @save_song
  cmp #F11
  beq @order_list_module
  cmp #KEY_UP
  beq @cursor_up_jump
  cmp #KEY_DOWN
  beq @cursor_down_jump
  cmp #KEY_LEFT
  beq @cursor_left_jump
  cmp #KEY_RIGHT
  beq @cursor_right_jump
  ; Disable tabbing for now becuase channel advancing doesn't work here
  ;cmp #KEY_TAB
  ;beq @cursor_tab_right_jump
  cmp #PETSCII_BRACKET_LEFT
  beq @decrease_octave
  cmp #PETSCII_BRACKET_RIGHT
  beq @increase_octave
  cmp #PETSCII_SHIFT_BACKSPACE
  beq @delete_channel_row_jump
  cmp #$2E    ; Alphanumeric, period, and a few things we don't want
  bpl @print_note_or_alphanumeric_jump
  jmp edit_pattern_loop

@cursor_up_jump:
  jmp @cursor_up
@cursor_down_jump:
  jmp @cursor_down
@cursor_left_jump:
  jmp @cursor_left
@cursor_right_jump:
  jmp @cursor_right
@cursor_tab_right_jump:
  jmp @cursor_tab_right
@delete_channel_row_jump:
  jmp @delete_channel_row
@print_note_or_alphanumeric_jump:
  jmp @print_note_or_alphanumeric
@play_pattern_jump:
  jmp @play_pattern
@play_song_at_row_jump:
  jmp @play_song_at_row
@stop_jump:
  jmp @stop_pattern

@help_module:
  jmp main
@play_song_module:
  jmp tracker::modules::play_song
@save_song:
  jmp tracker::modules::save_song
@order_list_module:
  jmp tracker::modules::orders

; Play pattern only (loop pattern over and over)
@play_pattern:
  lda #PLAY_PATTERN_STATE
  sta STATE
  ; We're only playing the pattern, so let's scroll
  lda #$01
  sta SCROLL_ENABLE
  ; Set row to 0 to make sure we start scrolling at the start of the pattern
  stz ROW_NUMBER
  jsr concerto_synth::activate_synth
  jsr play_irq
  jmp edit_pattern_loop

@play_song_at_row:
  lda #PLAY_SONG_STATE
  sta STATE
  stz SCROLL_ENABLE
  jsr concerto_synth::activate_synth
  jsr play_irq
  jmp edit_pattern_loop

@stop_pattern:
  jsr tracker::stop_song
  jsr reset_scroll_position
  jmp edit_pattern_loop

; Inc/Dec octave and update UI
@decrease_octave:
  lda user_octave
  beq @update_octave_end
  dec user_octave
  jmp @update_ui_octave
@increase_octave:
  lda user_octave
  cmp #MAX_OCTAVE
  beq @update_octave_end
  inc user_octave
  jmp @update_ui_octave

; TBD
@update_ui_octave:
@update_octave_end:
  jmp edit_pattern_loop

@cursor_up:
  jsr ui::cursor_up
  lda ROW_NUMBER
  beq @cursor_up_goto_bottom_of_pattern
  lda SCREEN_ROW
  beq @cursor_up_scroll_down
  dec ROW_NUMBER
  dec SCREEN_ROW
  jsr ui::print_row_number
  jmp @cursor_up_end
@cursor_up_goto_bottom_of_pattern:
  lda #$00
  sta VERA_L0_vscroll_h
  lda #$28    ; Roll pattern up so the bottom of the pattern is at the bottom of screen
  sta VERA_L0_vscroll_l
  lda #ROW_MAX - 1
  sta ROW_NUMBER
  lda #SCREEN_ROW_MAX
  sta SCREEN_ROW
  lda #$01
  sta cursor_layer
  lda cursor_x
  lda #$3F
  sta cursor_y
  jsr graphics::drawing::cursor_plot
  jmp @cursor_up_end
@cursor_up_scroll_down:
  jsr ui::scroll_pattern_down
  dec ROW_NUMBER
@cursor_up_end:
  jsr ui::print_row_number
  jmp edit_pattern_loop

@cursor_down:
  jsr ui::cursor_down
  inc ROW_NUMBER
  lda ROW_NUMBER
  cmp #ROW_MAX
  beq @cursor_down_goto_top_of_pattern
  lda SCREEN_ROW
  cmp #SCREEN_ROW_MAX
  beq @cursor_down_scroll_up
  inc SCREEN_ROW
  jmp @cursor_down_end
@cursor_down_goto_top_of_pattern:
  jsr reset_scroll_position
  jmp @cursor_down_end
@cursor_down_scroll_up:
  jsr ui::scroll_pattern_up
@cursor_down_end:
  jsr ui::print_row_number
  jmp edit_pattern_loop

@cursor_left:
  lda COLUMN_POS
  beq @cursor_left_channel
  cmp #INSTRUMENT_COLUMN_POSITIION
  beq @cursor_left_note
  jsr ui::cursor_left
  dec COLUMN_POS
  jmp edit_pattern_loop
@cursor_left_note:
  jsr ui::cursor_left
  jsr ui::cursor_left
  jsr ui::cursor_left
  stz COLUMN_POS
  jmp edit_pattern_loop
@cursor_left_channel:
  ; If we're at the 0th screen channel, check to see if we're on the
  ; 0th actual channel and, if so, we're already as far left as we can go.
  ; Otherwise, go left normally
  lda SCREEN_CHANNEL
  bne @cursor_move_left_channel
  ; If we're already at channel 0, we can't go left anymore
  lda START_CHANNEL
  beq @cursor_left_channel_end
  ; If we're on the first column but our left-most channel isn't zero,
  ; we need to move the pattern view over
@cursor_left_at_first_channel:
  dec START_CHANNEL
  jsr ui::draw_pattern_frame
  jsr ui::print_pattern
  ; Move to beginning of shifted channel
  lda #CURSOR_X_START
  sta cursor_x
  jsr graphics::drawing::cursor_plot
  stz COLUMN_POS
  dec CHANNEL_NUMBER
  jmp @cursor_left_channel_end
@cursor_move_left_channel:
  jsr ui::cursor_left
  jsr ui::cursor_left
  dec SCREEN_CHANNEL
  dec CHANNEL_NUMBER
  ; We're moving to the last column of the previous channel
  lda #LAST_COLUMN_POSITION
  sta COLUMN_POS
@cursor_left_channel_end:
  jmp edit_pattern_loop

@cursor_right:
  lda COLUMN_POS
  beq @cursor_right_note
  cmp #LAST_COLUMN_POSITION
  beq @cursor_right_channel
  jsr ui::cursor_right
  inc COLUMN_POS
  jmp edit_pattern_loop
@cursor_right_note:
  jsr ui::cursor_right
  jsr ui::cursor_right
  jsr ui::cursor_right
  lda #INSTRUMENT_COLUMN_POSITIION
  sta COLUMN_POS
  jmp edit_pattern_loop
@cursor_right_channel:
  ; If we're on the last column, we need to move the pattern view over
  lda SCREEN_CHANNEL
  cmp #NUM_CHANNELS_VISIBLE - 1
  bne @cursor_move_right_channel

  ; Check if we're not on the max possible channel
  lda START_CHANNEL
  clc
  adc #NUM_CHANNELS_VISIBLE - 1
  cmp #NUMBER_OF_CHANNELS
  bne @cursor_right_not_at_last_channel
  jmp edit_pattern_loop

@cursor_right_not_at_last_channel:
  inc START_CHANNEL
  jsr ui::draw_pattern_frame
  jsr ui::print_pattern

  ; Move to beginning of shifted channel
  lda #CURSOR_X_START_OF_LAST_CHNNAEL
  sta cursor_x
  jsr graphics::drawing::cursor_plot
  jmp @cursor_right_channel_end
@cursor_move_right_channel:
  jsr ui::cursor_right
  jsr ui::cursor_right
  inc SCREEN_CHANNEL
@cursor_right_channel_end:
  stz COLUMN_POS
  inc CHANNEL_NUMBER
  jmp edit_pattern_loop

@cursor_tab_right:
  ldx #$0C
  inc CHANNEL_NUMBER
  lda SCREEN_CHANNEL
  inc SCREEN_CHANNEL
@cursor_tab_right_loop:
  jsr ui::cursor_right
  dex
  bne @cursor_tab_right_loop
@cursor_tab_right_end:
  jmp edit_pattern_loop

; Delete the entire channel/row
@delete_channel_row:
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy

  ldx COLUMN_POS
  beq @print_periods
@goto_start_of_channel:
  jsr ui::cursor_left
  dex
  bne @goto_start_of_channel
@print_periods:
  stz COLUMN_POS
  ; Jump past colors
  lda #$21
  sta VERA_addr_high
  lda #SCREENCODE_PERIOD
  ldx #$0B  ; There's 11 dots in a pattern
@print_periods_loop:
  sta VERA_data0
  dex
  bne @print_periods_loop
  ; Disable stride
  lda #$01
  sta VERA_addr_high
  jsr @save_row_channel
  jmp @cursor_down


; If we're in the note column, print a note
; Otherwise print the hex-number the user typed
@print_note_or_alphanumeric:
  sei
  pha
  lda cursor_x
  ldy cursor_y
  jsr graphics::drawing::goto_xy
  lda COLUMN_POS
  beq @print_note
; Print the # the user typed.
@print_alphanumeric:
  pla
  cmp #PETSCII_AT
  bmi @print_numeric
  cmp #PETSCII_G  ; Do not print invalid chars
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
  lda COLUMN_POS
  cmp #LAST_COLUMN_POSITION
  beq @print_end
  jsr ui::cursor_right
  inc COLUMN_POS
  jmp @print_end

@print_note:
  lda #PATTERN_NOTE_COLOR
  sta COLOR
  lda #$11
  sta VERA_addr_high
  pla
  jsr @key_to_note

  lda #$01
  sta VERA_addr_high

  lda #PATTERN_INST_COLOR
  sta COLOR
  lda user_instrument
  jsr graphics::drawing::print_hex
  jsr @save_row_channel
  lda #$00
  sta COLUMN_POS
  jmp @cursor_down

@print_end:
  jsr @save_row_channel

  cli
  jmp edit_pattern_loop

@key_to_note:
  sbc #$2F      ; Subtract to offset the values for the LUT
  tay
  lda petscii_to_note,y
  jsr sound::decode_note
  lda NOTE_OCTAVE
  clc
  adc user_octave
  sta NOTE_OCTAVE
  jsr ui::print_note
  rts



; Write the current row we are on to the pattern
; This pulls the values from VRAM by figuring out
; which CHANNEL_NUMBER offset we are on, finding the beginning
; of that CHANNEL_NUMBER in VRAM, pulling the values, converting
; them and finally storing them back into the pattern data.
@save_row_channel:
  ; Do not interrupt saving
  sei

  ; First, figure out where we are in the pattern
  lda ROW_NUMBER
  jsr tracker::get_row

  ; If we already on channel 0 don't do any math
  lda #$00
  ldx CHANNEL_NUMBER
  beq @store_channel
@channel_skip_loop:
  clc
  adc #TOTAL_BYTES_PER_CHANNEL
  dex
  bne @channel_skip_loop
@store_channel:
  ; This is our channel offset
  ; We'll put it into Y down below
  pha

  ; Then find where we are on the screen
  lda SCREEN_CHANNEL
  jsr math::multiply_by_12
  clc
  adc #$03  ; For skipping past row numbers

  ; Load the ROW not the screen!
  ; Previous this was a really hard to catch bug. All rows fit in VRAM so
  ; the screen position doesn't matter for storing the actual values.
  ; Previously, SCREEN_ROW was being used here and that mean it kept just
  ; reading the same screen-row and storing it in the actual row. It was
  ; very confusing as it only came up when scrolling.
  ldy ROW_NUMBER

  jsr graphics::drawing::goto_xy

  ; Skip over colors
  lda #$21
  sta VERA_addr_high

  ; Read three to characters of note
  ; We do this first since we want to keep aligned with the rest of the
  ; pattern data (though if we find nulls, we'll skip some things)
  ldx VERA_data0
  ldy VERA_data0
  lda VERA_data0
  sta PITCH_TEMP

  cpx #SCREENCODE_PERIOD
  beq @note_null
  cpx #SCREENCODE_DASH
  beq @note_off
  cpx #SCREENCODE_ARROW_UP
  beq @note_rel

  lda screencode_to_note,x
  ; If there is a #, add one as it is a sharp
  cpy #SCREENCODE_HASH
  bne @not_sharp
  ; sharp, so add 1 to value
  clc
  adc #$01

@not_sharp:
  sta NOTE_NOTE
  ; Now add the pitch, noting that the pitch is actually the top nibble
  ; when stored in the pattern data
  lda PITCH_TEMP
  ; We can grab the numbers from the lower nibble and just ignore
  ; the top
  asl
  asl
  asl
  asl
  ora NOTE_NOTE

  jmp @store_note

@note_null:
  lda #NOTENULL
  jmp @store_note
@note_off:
  lda #NOTEOFF
  jmp @store_note
@note_rel:
  lda #NOTEREL

@store_note:
  ; This was our channel offset from above
  ply

  ;tya
  ;jsr graphics::kernal::printhex

  ; Store note
  sta (ROW_POINTER),y

  ; The next values are all 2-digit hex values
  ; so we can just do the same thing over and over

  ; Loop for instrument, volume, effect, and effect value
  ldx #$04
@store_rest_of_row_loop:
  ; Grab next two values in pattern VRAM
  lda VERA_data0
  sta r0
  lda VERA_data0
  sta r1

  ; Compare r1, if period, jump to storing null
  cmp #SCREENCODE_PERIOD
  beq @null_found

  ; Compare r0, if period, jump to storing null
  lda r0
  cmp #SCREENCODE_PERIOD
  beq @null_found

  ; If nulls were not found, convert value
  jsr graphics::drawing::chars_to_number
  jmp @inc_row_pointer

@null_found:
  lda #EFFNULL

@inc_row_pointer:
  ; Inc our row pointer
  iny

  sta (ROW_POINTER),y

  ; If we're on the instrument column (which is first in the loop)
  ; update the user's currently selected instrument
  cpx #$04
  bne @not_instrument
  sta user_instrument

@not_instrument:
  dex
  bne @store_rest_of_row_loop

@done_save:
  ;lda NOTE_NOTE
  ;jsr graphics::kernal::printhex


  lda #$01
  sta VERA_addr_high
  cli
  rts

; Reset pattern scroll/position
reset_scroll_position:
  lda #STATIC_PATTERN_SCROLL_H
  sta VERA_L0_vscroll_h
  lda #STATIC_PATTERN_SCROLL_L
  sta VERA_L0_vscroll_l
  stz ROW_NUMBER
  stz SCREEN_ROW
  lda #$01
  sta cursor_layer
  lda cursor_x
  lda #$00
  sta cursor_y
  jsr graphics::drawing::cursor_plot
  rts

.endproc
