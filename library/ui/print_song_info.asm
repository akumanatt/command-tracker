.proc print_song_info
print_song_info:
  print_string_macro song_title, #SONG_TITLE_X, #SONG_TITLE_Y, #TEXT_COLORS
  print_string_macro composer, #COMPOSER_X, #COMPOSER_Y, #TEXT_COLORS

  rts
.endproc
