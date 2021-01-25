.include "library/preamble.asm"
.include "library/x16.inc"
.include "library/macros.inc"
.include "library/printing/printhex.asm"
.include "library/printing/printhex16.asm"
.include "library/printing/printstring.asm"
.include "library/drawing/clearscreen.asm"
.include "library/drawing/drawcharacters.asm"
.include "library/drawing/loadscreen.asm"
.include "library/drawing/scroll.asm"
.include "library/math/add16.asm"
.include "library/math/mulby12.asm"
;include "library/math/mod8.asm"
;.include "library/math/divby12.asm"
;.include "library/files/loadfiletobank.asm"
.include "library/files/loadfile.asm"
;.include "library/files/loadfiletovram.asm"
.include "library/sound/printnote.asm"
.include "library/sound/printpattern.asm"
.include "library/sound/decodenote.asm"
.include "library/sound/pitch_table.inc"

.include "variables.inc"

start:
  lda #$00
  sta VERA_ctrl ; Select primary VRAM address
  sta VERA_addr_med ; Set primary address med byte to 0
  sta VERA_addr_low ; Set Primary address low byte to 0
  lda #$00
  sta VERA_addr_high ; Set primary address bank to 0, stride to 0
  lda #RES128x128x16
  sta VERA_L0_config
  sta VERA_L1_config
  ; enables 2nd layer (which is currently busted)
  lda #DC_VIDEO
  sta VERA_dc_video
  lda #$40
  sta VERA_L0_mapbase
  lda #$00
  sta VERA_L1_mapbase

  jsr clear_screen
  lda #$12
  jsr CHROUT
  lda #$9B
  jsr CHROUT

  jsr enable_irq

frame:
  ; Draw Frame
  ; Note for files, seems like the first 4 bytes of the file are skipped
  lda #<frame_filename
  sta r0
  lda #>frame_filename
  sta r0+1
  lda #$09  ; file length
  ;jsr load_file_to_vram
  ;jsr load_file_to_bank
  jsr load_file
  jsr load_screen
  ;lda #<RAM_WIN
  ;sta r0+0
  ;lda #>RAM_WIN
  ;sta r0+1
  ;jsr draw_characters

  jsr print_pattern

  ; Display song title
  lda #SONG_TITLE_X    ;x
  sta r1
  lda #SONG_TITLE_Y    ;y
  sta r2
  lda #TITLE_COLORS   ;color
  sta r3
  lda #<song_title_string
  sta r0+0
  lda #>song_title_string
  sta r0+1
  jsr print_string

  ; Display song author
  lda #AUTHOR_TITLE_X    ;x
  sta r1
  lda #AUTHOR_TITLE_Y    ;y
  sta r2
  lda #TITLE_COLORS   ;color
  sta r3
  lda #<author_string
  sta r0+0
  lda #>author_string
  sta r0+1
  jsr print_string

  ; Reverse works! In 16 and 256
  ; I think it's just using other tiles somewhere in VERA
  ; Also not sure how the layers work with 256 and inversion
  lda #$12
  jsr CHROUT

set_vera_psg:
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

  ; Load pattern to the bottom vera layer
  ; jsr load_pattern_to_vera


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
  jsr play_row
  jmp @vblank_end

@vblank_end:
  clc
  jmp (PREVIOUS_ISR_HANDLER)        ; Pass control to the previous handler

play_row:
  ; Set base vera address to PSG
  lda #$01
  sta VERA_addr_high
  lda #$F9
  sta VERA_addr_med

  ; get note value as our offset
  ldy ROW_COUNT
  ldx pattern,y ;get note from the pattern
  txa
  jsr decode_note

  ; Get numeric value of note
  jsr mulby12
  adc NOTE_NOTE
  sta NOTE_NUMERIC
  tax

  lda NOTE_NOTE
  cmp #NOTEREL
  beq note_off     ; same as note off for now
  cmp #NOTEOFF
  beq note_off
  cmp #NOTENULL
  ;beq print_only_note
  beq print_stuff

  ;$1F9C0 - $1F9FF
  ; low the low byte of Note
  lda #$C0
  sta VERA_addr_low
  lda pitch_dataL,x
  sta VERA_data0
  ; load high byte of note
  lda #$C1
  sta VERA_addr_low
  lda pitch_dataH,x
  sta VERA_data0

  ; Set pan/vol
  lda #$C2
  sta VERA_addr_low
  lda #$FF
  sta VERA_data0

  jmp print_stuff

note_off:
  lda #$C2
  sta VERA_addr_low
  lda #$00
  sta VERA_data0

print_stuff:
;  gotocoords 5,9
;  ldy ROW_COUNT
;  lda pattern,y
;  ;txa
;  jsr printhex
;  gotocoords 6,9
;  lda NOTE_NUMERIC
;  jsr printhex
;print_only_note:
;  gotocoords 7,9
;  jsr print_note

print_row_count:
  gotocoords ROW_Y,ROW_X
  lda ROW_COUNT       ; Get the current row conunt
  jsr printhex        ; print it
  ; scroll 2nd layer (this busted)
  jsr scroll

inc_row:
  lda ROW_COUNT       ; get it again (printhex blows it away)
  clc
  adc #1              ; increment row count
  sta ROW_COUNT       ; store it

  cmp #ROW_MAX        ; see if we're at the row max
  beq @row_max      ; if not, jump to end; if so, go to row_max

  ; Oh no it's slow!?

  rts
@row_max:
  lda 0
  sta ROW_COUNT
return:
  rts


enable_irq:
  ; Setup irq handler
  ; We load the address of our interrupt handler into a special memory
  ;   location. Basically when an interrupt triggers, this is the
  ;   routine the CPU will execute.
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

;pattern_using_tracker_notes:
pattern:
; DFAD
.byte   $42, $FF
.byte   $45, $FF
.byte   $49, $FF
.byte   $52, $FF
.byte   $42, $FF
.byte   $FF, $FF
.byte   $49, $FF
.byte   $FF, $FF
.byte   $52, $FF
.byte   $49, $FF
.byte   $45, $FF
.byte   $52, $FF
.byte   $49, $FF
.byte   $FE, $FF
.byte   $42, $FF
.byte   $FD, $FF


; [x : y : character : color], [x : y; ,...]
file_data: .byte 0
