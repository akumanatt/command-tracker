; Note for files, seems like the first 4 bytes of the file are skipped
.proc load_file_to_bank
  ;a = filename length
  FILENAME=r0
load_file_to_bank:
	ldx	r0
	ldy	r0+1
	jsr	SETNAM	;SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
	lda	#$02
	ldx	#DISK_DEVICE	;2020-01-20 JB #94 - x16emu R36, host drive is now 8
	ldy	#$00
	jsr	SETLFS	;SETLFS A=LOGICAL NUMBER X=DEVICE NUMBER Y=SECONDARY
  lda	#$00
	ldx	#<RAM_WIN
	ldy	#>RAM_WIN
	jsr	LOAD	;LOAD FILE A=0 FOR LOAD X/Y=LOAD ADDRESS
	rts
.endproc
