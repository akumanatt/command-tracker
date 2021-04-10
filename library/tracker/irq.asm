; Setup playback IRQ
.proc play_irq
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

vblank:
  sei
  jsr concerto_synth::synth_engine::synth_tick

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
  cpx SPEED
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

  ; Only evaluate getting the next pattern if we are playing the entire song.
  ; Otherwise, skip past it.
  lda STATE
  cmp #PLAY_SONG_STATE
  bne @get_row
  jsr tracker::get_next_pattern
@get_row:
  jsr tracker::get_row             ; get the current row of pattern, put in ROW_POINTER
  jsr tracker::play_row
  jsr ui::scroll_pattern          ; note we check for scroll in the routine
@print_row_number:
  jsr ui::print_row_number
  jsr tracker::inc_row

@vblank_end:
  clc
  jmp (PREVIOUS_ISR_HANDLER)        ; Pass control to the previous handler

.endproc

; Restore the previous IRQ routine
.proc disable_irq
  ldx #$0
  lda PREVIOUS_ISR_HANDLER,x
  sta ISR_HANDLER,x
  inx
  lda PREVIOUS_ISR_HANDLER,x
  sta ISR_HANDLER,x
  rts
.endproc
