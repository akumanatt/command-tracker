.include "library/preamble.asm"
.include "library/x16.inc"
.include "library/macros.inc"
.include "library/printing/printhex.asm"
.include "library/printing/vera/printhex.asm"
.include "library/printing/vera/printchar.asm"
.include "library/printing/printhex16.asm"
.include "library/printing/printstring.asm"
;.include "library/drawing/clearscreen.asm"
.include "library/drawing/clearvram.asm"
.include "library/drawing/vera/gotoxy.asm"
.include "library/drawing/drawcharacters.asm"
.include "library/drawing/loadscreen.asm"
.include "library/drawing/scrollpattern.asm"
.include "library/drawing/drawframe.asm"
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

.include "library/tracker/playrow.asm"
.include "library/tracker/getrow.asm"
.include "library/tracker/getpattern.asm"
.include "library/tracker/incrow.asm"
.include "library/tracker/updaterowcount.asm"

.include "variables.inc"



start:
.include "setup.asm"
  lda #<pattern
  sta ROW_POINTER
  lda #>pattern
  sta ROW_POINTER+1

  ldy #$00  ; offset for row data
  ; Print note
  lda (ROW_POINTER),y
  jsr printhex
  ldy #$01
  lda (ROW_POINTER),y
  jsr printhex

  lda ROW_POINTER
  adc #$02
  sta ROW_POINTER

  ldy #$00  ; offset for row data
  ; Print note
  lda (ROW_POINTER),y
  jsr printhex
  ldy #$01
  lda (ROW_POINTER),y
  jsr printhex

  jsr print_pattern


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
