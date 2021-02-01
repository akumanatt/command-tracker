.include "includes.inc"

start:
  sei
  jsr setup

  ; Hard set scroll
  lda #$01
  sta SCROLL_ENABLE

  ; Set state to 0 (idle/stopped)
  lda #$00
  sta STATE

  ; First stuff before song starts to play
  jsr ui::draw_frame
  ;jsr enable_irq

play_song:
  sei
  ; Check current state, if 0, don't remove ISR
  lda STATE
  beq start_song
  jsr disable_irq
start_song:
  ; First stuff before song starts to play
  jsr ui::draw_frame
  jsr ui::draw_pattern_frame
  jsr sound::stop_all_voices
  jsr tracker::load_patterns
  ldy #$00
  sty ORDER_NUMBER
  lda order_list,y
  sty ROW_COUNT
  sta RAM_BANK
  sta PATTERN_NUMBER
  jsr ui::print_song_info
  jsr ui::print_speed
  jsr ui::print_number_of_orders
  jsr ui::print_current_order
  jsr ui::print_current_pattern_number
  jsr ui::print_pattern

  ; Prepare for playback
  jsr sound::setup_voices
  jsr enable_irq

  lda #PLAY_STATE
  sta STATE


  cli
  jmp main_loop

stop_song:
  sei
  ; Check if we're already stopped
  lda STATE
  beq stopping_song
  jsr disable_irq
stopping_song:
  jsr sound::stop_all_voices
  ; Reset scroll to beginning
  lda #PATTERN_SCROLL_START_H
  sta VERA_L0_vscroll_h
  lda #PATTERN_SCROLL_START_L
  sta VERA_L0_vscroll_l
  cli
  jmp main_loop


; Loop on user interaction
main_loop:
  wai
check_keyboard:
  jsr GETIN  ;keyboard
  cmp #F8
  beq stop_song
  cmp #F5
  beq play_song
  cmp #F11
  beq edit_order_list_pane
  jmp main_loop


edit_order_list_pane:
  jsr ui::draw_frame
  jsr ui::draw_orders_frame
  jmp main_loop

vblank:
  sei

@vblank_next:
  ; Check to see if the VBLANK was triggered. This is in case the intterupt
  ;   was triggered by something else. We just want VBLANK.
  lda VERA_isr         ; Load contents of VERA's ISR
  and #VBLANK_MASK    ; Mask first bit.
  clc
  cmp #VBLANK_MASK    ; If it's 1, we blanked, continue
  bcc @vblank_end      ; if it's not 1, return

  ; Clear the VBLANK Interrupt Status
  lda VERA_isr
  and #VBLANK_MASK
  sta VERA_isr

  ldx VBLANK_SKIP_COUNT
  cpx #SPEED
  beq @vblank_work

@inc_vblank_skip:
  inx
  stx VBLANK_SKIP_COUNT
  jmp @vblank_end

; Here we do actual work in the vblank
; First we zero out the vblank skip then jsr over to whatever routines
; we need to do for the vblank
@vblank_work:
  ldx #0
  stx VBLANK_SKIP_COUNT

  jsr tracker::get_next_pattern
  jsr tracker::get_row             ; get the current row of pattern, put in ROW_POINTER

  jsr tracker::play_row
  jsr ui::scroll_pattern
  jsr ui::print_row_count
  jsr tracker::inc_row

@vblank_end:
  clc
  jmp (PREVIOUS_ISR_HANDLER)        ; Pass control to the previous handler



enable_irq:
  ; Setup irq handler
  ; We load the address of our interrupt handler into a special memory
  ;   location. Basically when an interrupt triggers, this is the
  ;   routine the CPU will execute.
  ldx #$0
  lda ISR_HANDLER,x
  sta PREVIOUS_ISR_HANDLER,x
  lda #<vblank
  sta ISR_HANDLER,x
  inx
  lda ISR_HANDLER,x
  sta PREVIOUS_ISR_HANDLER,x
  lda #>vblank
  sta ISR_HANDLER,x
@end:
  rts

disable_irq:
  ldx #$0
  lda PREVIOUS_ISR_HANDLER,x
  sta ISR_HANDLER,x
  inx
  lda PREVIOUS_ISR_HANDLER,x
  sta ISR_HANDLER,x
@end:
  rts


.include "data.inc"
