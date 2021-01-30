.proc print_song_info
print_song_info:
  ; Display song title
  lda #SONG_TITLE_X    ;x
  sta r1
  lda #SONG_TITLE_Y    ;y
  sta r2
  lda #TITLE_COLORS   ;color
  sta r3
  lda #<song_title
  sta r0+0
  lda #>song_title
  sta r0+1
  jsr graphics::drawing::print_string

  ; Display song author
  lda #AUTHOR_TITLE_X    ;x
  sta r1
  lda #AUTHOR_TITLE_Y    ;y
  sta r2
  lda #TITLE_COLORS   ;color
  sta r3
  lda #<author
  sta r0+0
  lda #>author
  sta r0+1
  jsr graphics::drawing::print_string
  rts
.endproc
