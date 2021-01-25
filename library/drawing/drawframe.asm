.proc draw_frame
draw_frame:
  ; Draw Frame
  ; Note for files, seems like the first 4 bytes of the file are skipped
  lda #<frame_filename
  sta r0
  lda #>frame_filename
  sta r0+1
  lda #$09  ; file length
  jsr load_file
  jsr load_screen

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
  ;lda #$12
  ;jsr CHROUT
.endproc
