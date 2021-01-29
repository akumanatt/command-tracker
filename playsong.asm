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
.include "library/drawing/vera/loadpalette16.asm"
.include "library/drawing/drawcharacters.asm"
.include "library/drawing/loadscreen.asm"
.include "library/drawing/scrollpattern.asm"
.include "library/drawing/drawframe.asm"
.include "library/math/add16.asm"
.include "library/math/mod8.asm"
.include "library/math/mulby12.asm"
.include "library/math/multiply16.asm"
.include "library/math/settopnibble.asm"
.include "library/files/loadfile.asm"
.include "library/printing/printnote.asm"
.include "library/printing/printpattern.asm"
.include "library/printing/printrowcount.asm"
.include "library/printing/printspeed.asm"
.include "library/printing/printcurrentorder.asm"
.include "library/printing/printnumberoforders.asm"
.include "library/printing/printcurrentpatternnumber.asm"
.include "library/sound/decodenote.asm"
.include "library/sound/pitch_table.inc"
.include "library/tracker/playrow.asm"
.include "library/tracker/getrow.asm"
.include "library/tracker/getpattern.asm"
.include "library/tracker/getnextpattern.asm"
.include "library/tracker/loadpatterns.asm"
.include "library/tracker/incrow.asm"
.include "variables.inc"

.include "setup.asm"

start:
  jsr setup

  ; Hard set scroll
  lda #$01
  sta SCROLL_ENABLE

  ; First stuff before song starts to play
  jsr load_patterns
  jsr enable_irq
  jsr draw_frame
  jsr print_speed
  jsr print_number_of_orders

  ; Get the first order
  ldy #$00
  sty ORDER_NUMBER
  lda order_list,y
  sta RAM_BANK
  sta PATTERN_NUMBER
  jsr print_current_order
  jsr print_current_pattern_number
  jsr print_pattern



; This is to configure the base instrument - it's a placeholder
set_voice_1:
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

set_voice_2:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med
  lda #$C6
  sta VERA_addr_low
  lda #$FF
  sta VERA_data0
  lda #$C7
  sta VERA_addr_low
  lda #%00010000
  sta VERA_data0

set_voice_3:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med
  lda #$CA
  sta VERA_addr_low
  lda #$FF
  sta VERA_data0
  lda #$CB
  sta VERA_addr_low
  lda #%11000000
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

  jsr get_next_pattern
  jsr get_row             ; get the current row of pattern, put in ROW_POINTER

  jsr play_row
  jsr scroll_pattern
  jsr print_row_count
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

.include "data.inc"
