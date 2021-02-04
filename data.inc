.DATA
; Don't think we need this anymore - we just stop at the first 00
;order_list_length: .byte $03
; Order list is assumed to be up to 256 ($FF)
; we're manually loading it here, but reserving the rest
; so we don't run out of RAM while testing stuffs
order_list: .byte $01,$02,$03,$04
.res $FC

; Where to start the order list display from
; (such as if we're scrolled further down)
order_list_start: .byte $00

; Where the cursor is in the order list
order_list_position: .byte $00

; Which column the cursor is in (there are only 2 so 0/1)
order_list_column: .byte $00



key: .byte $00
cursor_x: .byte $00
cursor_y: .byte $00
cursor_color: .byte $00
cursor_old_color: .byte $00
cursor_layer: .byte $00

first_channel_in_pattern_view: .byte $00

note_names:  .byte "ccddeffggaab-^-."
note_sharps: .byte "-#-#--#-#-#--^-."
; "-#-#-#-36-#-#-"
;note_names: .byte  $06,$06,$07,$07,$08,$08,$09,$0A,$0A,$0B,$0B,$0C
;note_sharps: .byte "-#-#-#--#-#-"

command_tracker_string: .byte "command tracker v0.000",0
song_label: .byte "song:",0
composer_label: .byte "by  :",0
speed_label: .byte "spd:",0
pattern_label: .byte "pat:",0
order_label: .byte "ord:  /",0
row_label: .byte "row:",0

song_title: .byte "bad apple",0
author: .byte "m00dawg",0

order_screen_help_msg: .byte "press enter to save orders",0

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
