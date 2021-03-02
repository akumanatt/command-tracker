; Load a song from disk

.proc load_song
  ; Constants
  PATTERN_NUMBER = r15
  FILE_VERSION = r15+1

  sei
  jsr files::open_for_read

  ; OS File header (unused)
  jsr CHRIN
  jsr CHRIN
  ; Version of CMT save file format
  jsr CHRIN
  sta FILE_VERSION
  ; Starting song speed
  jsr CHRIN
  sta SPEED

; Title
@read_title:
  ldy #$FF
@read_title_loop:
  iny
  jsr CHRIN
  sta song_title,y
  cpy #SONG_TITLE_MAX_LENGTH
  bne @read_title_loop

; Composer
@read_composer:
  ldy #$FF
@read_composer_loop:
  iny
  jsr CHRIN
  sta composer,y
  cpy #COMPOSER_MAX_LENGTH
  bne @read_composer_loop

; Orders
@read_order_list:
  ldy #$00
@read_order_list_loop:
  jsr CHRIN
  sta order_list,y
  iny
  bne @read_order_list_loop

; Patterns
@read_patterns_loop:
  ; This is the pattern number, which will get placed into hiram in
  ; the same page number
  jsr CHRIN
  beq @read_patterns_done
  sta RAM_BANK

@read_patterns_page_loop:
  ; Reset pattern pointer back to default
  lda #<PATTERN_ADDRESS
  sta PATTERN_POINTER
  lda #>PATTERN_ADDRESS
  sta PATTERN_POINTER + 1

  ; To count down 8192 bytes, we loop 20 times
  ; As 8192 bytes == $2000 in hex
  ldx #$20
  ldy #$00
@read_patterns_pattern_data_loop:
  jsr CHRIN
  sta (PATTERN_POINTER),y
  iny
  ; Loop until y rolls over
  bne @read_patterns_pattern_data_loop
@read_patterns_pattern_data_loop_end:
  ; When we're done with 256 bytes, we decrement x, reset y,
  ; jump to the next 256 bytes and do it again
  dex
  beq @get_pattern_end
  ldy #$00
  inc PATTERN_POINTER + 1
  jmp @read_patterns_pattern_data_loop

@get_pattern_end:
  jmp @read_patterns_loop

@read_patterns_done:
  lda #<PATTERN_ADDRESS
  sta PATTERN_POINTER
  lda #>PATTERN_ADDRESS
  sta PATTERN_POINTER + 1


@end:
  jsr files::close_file
  cli
  rts
.endproc
