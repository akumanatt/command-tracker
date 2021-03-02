; Routines to open and close files

; Constants
FILE_NUMBER = $01  ; set to 1 for now as we will only be opening 1 file at a time
DEVICE = $08  ; set to 8 for host system (emulator)
SECONDARY_ADDR_WRITE = $01 ; Ignore file header
SECONDARY_ADDR_READ = $00 ; Don't ignore file header

; Use full filename, including @:
.proc open_for_write
@start:
  ldy #$00
; Get the length by finding the first space
@find_filename_length:
  lda full_filename,y
  cmp #SCREENCODE_BLANK
  beq @set_filename
  iny
  jmp @find_filename_length
@set_filename:
  tya
  ldx #<full_filename
  ldy #>full_filename
  jsr SETNAM

@overwrite:
  lda #FILE_NUMBER
  jsr CLOSE

@set_parameters:
  lda #FILE_NUMBER
  ldx #DEVICE
  ldy #SECONDARY_ADDR_WRITE
  jsr SETLFS
  jsr OPEN
  ldx #FILE_NUMBER
  jsr CHKOUT
@end:
  rts
.endproc

.proc open_for_read
@start:
  ldy #$00
; Get the length by finding the first space
@find_filename_length:
  lda filename,y
  cmp #SCREENCODE_BLANK
  beq @set_filename
  iny
  jmp @find_filename_length
@set_filename:
  tya
  ldx #<filename
  ldy #>filename
  jsr SETNAM

@set_parameters:
  lda #FILE_NUMBER
  ldx #DEVICE
  ldy #SECONDARY_ADDR_READ
  jsr SETLFS
  jsr OPEN
  ldx #FILE_NUMBER
  jsr CHKIN
@end:
  rts
.endproc


; Close file
.proc close_file
  lda #FILE_NUMBER
  jsr CLOSE
  jsr CLRCHN
  rts
.endproc
