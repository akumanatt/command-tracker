.proc print_song_info
print_song_info:
  ; Display song title
  print_string_macro song_title, #SONG_TITLE_X, #SONG_TITLE_Y, #TITLE_COLORS


  ; Display song author
  lda #COMPOSER_X    ;x
  sta r1
  lda #COMPOSER_Y    ;y
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
