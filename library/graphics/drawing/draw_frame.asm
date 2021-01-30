.proc draw_frame
draw_frame:
  ; Draw Frame
  ; Note for files, seems like the first 4 bytes of the file are skipped
  lda #<frame_filename
  sta r0
  lda #>frame_filename
  sta r0+1
  lda #$09  ; file length
  jsr files::load
  jsr load_screen
.endproc
