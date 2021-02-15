; Save current loaded song to disk

; Rough process
; Get filename, add .CMT to it
; Call SETNAM, a = len, x/y hi/lo pointers to filename
; Call SETLFS, a = logical file #, x = dev #, y = secondary addr
;   a = file id (if opening multiple filess) - for now, 1
;   x = 8, host drive on emu
;   y = 0
; OPEN and CHKOUT file
; Write bytes
; Call CLOSE


.proc save_song
  ; Constants
  FILE_NUMBER = $01  ; set to 1 for now as we will only be opening 1 file at a time
  DEVICE = $08  ; set to 8 for host system (emulator)
  SECONDARY_ADDR = $01 ; Ignore file header

@set_filename:
  lda #$06    ; hardcoded since 'song' is 4 characaters
  ldx #<filename
  ldy #>filename
  jsr SETNAM

; This allows overwriting the file
@close_file:
  lda #FILE_NUMBER
  jsr CLOSE

@set_file_parameters:
  lda #FILE_NUMBER
  ldx #DEVICE
  ldy #SECONDARY_ADDR
  jsr SETLFS

@open_file:
  jsr OPEN

  ldx #FILE_NUMBER
  jsr CHKOUT
  jsr debug::printhex

@write_bytes:
  lda #FILE_VERSION
  jsr CHROUT
  lda SPEED
  jsr CHROUT

@write_title:
  ldx #$00
@write_title_loop:
  lda song_title,x
  jsr CHROUT
  inx
  cpx #$10
  bne @write_title_loop

@write_composer:
  ldx #$00
@write_composer_loop:
  lda composer,x
  jsr CHROUT
  inx
  cpx #$10
  bne @write_composer_loop

@write_order_list:
  ldx #$00
@write_order_list_loop:
  lda order_list,x
  jsr CHROUT
  inx
  cpx #$FF
  bne @write_order_list_loop

; This is super wasteful as we're just grabbing full pages from himemory
; as this makes the count easier :P In reality, patterns are currently
; 8000 bytes.
@write_patterns:
  ; Remember, first pattern is at page 1 not 0
  ; but we set it to 0 so we can increment at the top of the loop
  ldx #$00
@write_patterns_page_loop:
  ; Reset pattern pointer back to default
  lda #<PATTERN_ADDRESS
  sta PATTERN_POINTER
  lda #>PATTERN_ADDRESS
  sta PATTERN_POINTER + 1

  inx
  stx RAM_BANK
  phx
  ; To count down 8192 bytes, we loop 20 times
  ; As 8192 bytes == $2000 in hex
  ldx #$20
  ldy #$00
@write_patterns_pattern_data_loop:
  lda (PATTERN_POINTER),y
  jsr CHROUT
  iny
  ; Loop when y rolls over
  bne @write_patterns_pattern_data_loop
@write_patterns_pattern_data_loop_end:
  ; When we're done with one page, we decrement x, reset y
  dex
  beq @write_patterns_page_loop_end
  ldy #$00
  jmp @write_patterns_pattern_data_loop

@write_patterns_page_loop_end:
  ; jump to the next 256 bytes
  inc PATTERN_POINTER + 1

  ;cpx #$FF actually I think we can just loop on overflow (0)
  ;cpx #$01  ;only write 2 patterns for testing
  ; Branch until rollover
  plx
  ;cpx #$F
  bne @write_patterns_page_loop


@end:
  lda #FILE_NUMBER
  jsr CLOSE
  jsr CLRCHN

  ; Reset pattern pointer back to default
  lda #<PATTERN_ADDRESS
  sta PATTERN_POINTER
  lda #>PATTERN_ADDRESS
  sta PATTERN_POINTER + 1

  lda #$AA
  jsr debug::printhex

  rts
.endproc
