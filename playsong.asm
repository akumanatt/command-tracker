; You forgot to include the insturment #.....
; You forgot to include the insturment #.....
; You forgot to include the insturment #.....
; You forgot to include the insturment #.....
; You forgot to include the insturment #.....
; Also add speed readout




.include "library/preamble.asm"
.include "library/x16.inc"
.include "library/macros.inc"
.include "library/printing/printhex.asm"
.include "library/printing/vera/printhex.asm"
.include "library/printing/vera/printchar.asm"
.include "library/printing/printhex16.asm"
.include "library/printing/printstring.asm"
.include "library/drawing/clearvram.asm"
.include "library/drawing/vera/gotoxy.asm"
.include "library/drawing/drawcharacters.asm"
.include "library/drawing/loadscreen.asm"
.include "library/drawing/scrollpattern.asm"
.include "library/drawing/drawframe.asm"
.include "library/math/add16.asm"
.include "library/math/mulby12.asm"
.include "library/files/loadfile.asm"
.include "library/printing/printnote.asm"
.include "library/printing/printpattern.asm"
.include "library/sound/decodenote.asm"
.include "library/sound/pitch_table.inc"
.include "library/tracker/playrow.asm"
.include "library/tracker/getrow.asm"
.include "library/tracker/getpattern.asm"
.include "library/tracker/incrow.asm"
.include "library/tracker/updaterowcount.asm"


.include "variables.inc"

start:
.include "setup.asm"
  jsr enable_irq
  jsr draw_frame


  jsr get_pattern
  ; This would be in the order/pattern fetch code
  jsr print_pattern

; This is to configure the base instrument - it's a placeholder
set_saw:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med
  lda #$C2
  sta VERA_addr_low
  lda #$FF
  sta VERA_data0
  lda #$C3
  sta VERA_addr_low
  lda #%01000000
  sta VERA_data0

@loop:
  jmp @loop

vblank:
  sei

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

  jsr get_row             ; get the current row of pattern, put in ROW_POINTER
  jsr play_row
  jsr scroll_pattern
  jsr update_row_count
  jsr inc_row
  jmp @vblank_end

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

  ; Enable VBLANK Interrupt
  ; We will use VBLANK from the VERA as our time keeper, so we enable
  ; the VBLANK interupt
  lda #VBLANK_MASK
  sta VERA_ien
  rts

.segment "DATA"
SCROLL_ENABLE: .byte $01


note_names:  .byte "ccddeffggaab-^-."
note_sharps: .byte "-#-#--#-#-#--^-."
; "-#-#-#-36-#-#-"
;note_names: .byte  $06,$06,$07,$07,$08,$08,$09,$0A,$0A,$0B,$0B,$0C
;note_sharps: .byte "-#-#-#--#-#-"
;frame_filename: .byte "frame.hex"
frame_filename: .byte "frame.hex"
heart_filename: .byte "heart.hex"
song_title_string: .byte "first song 123!",0
author_string: .byte "m00dawg",0

.include "pattern.inc"

; [x : y : character : color], [x : y; ,...]
file_data: .byte $01
