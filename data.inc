.segment "DATA"
order_list_length: .byte $03
order_list: .byte $01,02,$03,$04

key: .byte $00

note_names:  .byte "ccddeffggaab-^-."
note_sharps: .byte "-#-#--#-#-#--^-."
; "-#-#-#-36-#-#-"
;note_names: .byte  $06,$06,$07,$07,$08,$08,$09,$0A,$0A,$0B,$0B,$0C
;note_sharps: .byte "-#-#-#--#-#-"
;frame_filename: .byte "frame.hex"
frame_filename: .byte "frame.hex"
heart_filename: .byte "heart.hex"
song_title: .byte "bad apple",0
author: .byte "m00dawg",0

; Override the 16 color palette
; gb,r
palette:
.byte $01,$00     ; super dark blue
.byte $FF,$0F     ; white
.byte $00,$0F     ; red
.byte $4F,$04     ; cyan
.byte $04,$0A     ; purple
.byte $D0,$00     ; green
.byte $0F,$00     ; blue
.byte $F0,$0F     ; yellow
.byte $50,$0F     ; orange
.byte $30,$0A     ; brown
.byte $55,$0F     ; light red
.byte $22,$02     ; dark grey
.byte $44,$04     ; grey
.byte $F5,$05     ; light green
.byte $9F,$0A     ; light blue
.byte $88,$08     ; light gray

.include "song.inc"

; [x : y : character : color], [x : y; ,...]
file_data: .byte $01
