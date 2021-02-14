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
  FILE_NUMBER = $02  ; set to 1 for now as we will only be opening 1 file at a time
  DEVICE = $08  ; set to 8 for host system (emulator)
  SECONDARY_ADDR = $01 ; I don't know why this needs to be set to 1.

@set_filename:
  lda #$04    ; hardcoded since 'song' is 4 characaters
  ldx #<filename
  ldy #>filename
  jsr SETNAM

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
  lda #$01
  jsr CHROUT
  lda #$02
  jsr CHROUT
  lda #$03
  jsr CHROUT
  lda #$04
  jsr CHROUT
  lda #$05
  jsr CHROUT


@end:
  lda #FILE_NUMBER
  jsr CLOSE
  jsr CLRCHN
  lda #$AA
  jsr debug::printhex

  rts
.endproc
