; Save current loaded song to disk

; Current Rough process:
; 1. Call SETNAM, a = len, x/y hi/lo pointers to filename
; 2. Close the file, which indicates we want to overwrite it (apparently)
;    Note you still have to prefix the filename is @: for that to work
; 3. Call SETLFS, a = logical file #, x = dev #, y = secondary addr
;   a = file id (if opening multiple filess) - for now, 1
;   x = 8, host drive on emu
;   y = 0
; 4. OPEN and CHKOUT file
; 5. Write the file version and speed - these are easy single byte writes
; 6. Write the title, author, both hard aligned to 16 bytes
; 7. Write the complete order list (255 bytes)
;    Source of optimization here, we don't necessarily need to do that, but
;    if someone wanted to jump around the order list (allowable via a pattern
;    effect), this allows them to jump _anywhere_. But that's a minor benefit
;    and it's mostly just to make things simpler.
; 8. Sort the order list and put it somewhere. This is so we have all the
;    patterns in order
; 9. Start writing patterns, by looking at the sorted order list. We ignore
;    00 patterns and also keep track of the previously saved pattern so we
;    only write unique rows. Write the pattern number first, then write
;    the entire HiRAM page. We only need 8000 bytes but for now are writing
;    all 8192. It makes the looping easier
;    (we just loop over 256 bytes 20 times)
; 10. Write a $00 indicating there are no more patterns
; 11. Close file.


.proc save_song
  ; Constants
  FILE_NUMBER = $01  ; set to 1 for now as we will only be opening 1 file at a time
  DEVICE = $08  ; set to 8 for host system (emulator)
  SECONDARY_ADDR = $01 ; Ignore file header

  ; Vars
  ; A variable to store the pattern number so that we skip over duplicates
  ; in the sorted order list
  PATTERN_NUMBER = r15

@set_filename:
  ldy #$FF
  ldx #FILENAME_MAX_LENGTH
; Get the length by finding the first space
@find_filename_length:
  iny
  lda full_filename,y
  dex
  beq @set_filename
  cmp #SCREENCODE_BLANK
  bne @find_filename_length
@set_filename_end:
  tya
  ldx #<full_filename
  ldy #>full_filename
  jsr SETNAM

; This allows overwriting the file, though note it still requires
; using @: as a prefix of the filename.
@overwrite_file:
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
  bne @write_order_list_loop

; Sort the order list first, which will be used to store only the patterns
; that have been defined in the order list
@sort_order_list:
  ; Copy order list to the sorted area
  lda #<order_list
  sta r0
  lda #>order_list
  sta r0+1
  lda #<order_list_sorted
  ; r1 is used by MEMORY_COPY
  ; r13 is used by math::sort8
  ; Just trying to save a few cycles by doing this all at once
  sta r1
  sta r13
  lda #>order_list_sorted
  sta r1+1
  sta r13+1
  lda #$FF
  ; Same as above, r2 used by MEMORY_COPY, r14 by sort8
  sta r2
  sta r14
  jsr MEMORY_COPY
  jsr math::sort8


; This is super wasteful as we're just grabbing full pages from himemory
; as this makes the count easier :P In reality, patterns are currently
; 8000 bytes.
@write_patterns:
  ; Set pattern number to 00 since we haven't saved any patterns yet.
  stz PATTERN_NUMBER
  ; Set loop counter for sorter order list array
  ldy #$00

; Pattern loop which reads the sorted order list and writes unique patterns
; to the file, writing the pattern number first and then the full hi-mem
; page data for that pattern (pattern number == page number)
@get_pattern_loop:
  lda order_list_sorted,y
  ; Push our order list index
  phy
  ; If we see a zero, we skip. This is becuse we are currently sorting
  ; the ENTIRE order list, so all the zero's get pushed up to the beginning.
  beq @get_pattern_end
  ; Now check to see if we have already saved the pattern (skip duplicates)
  cmp PATTERN_NUMBER
  beq @get_pattern_end
  sta PATTERN_NUMBER
  sta RAM_BANK
  ; Write the pattern number
  jsr CHROUT

@write_patterns_page_loop:
  ; Reset pattern pointer back to default
  lda #<PATTERN_ADDRESS
  sta PATTERN_POINTER
  lda #>PATTERN_ADDRESS
  sta PATTERN_POINTER + 1

  ; To count down 8192 bytes, we loop 20 times
  ; As 8192 bytes == $2000 in hex
  ldx #$20
  ldy #$00
@write_patterns_pattern_data_loop:
  lda (PATTERN_POINTER),y
  jsr CHROUT
  iny
  ; Loop until y rolls over
  bne @write_patterns_pattern_data_loop
@write_patterns_pattern_data_loop_end:
  ; When we're done with 256 bytes, we decrement x, reset y,
  ; jump to the next 256 bytes and do it again
  dex
  beq @get_pattern_end
  ldy #$00
  inc PATTERN_POINTER + 1
  jmp @write_patterns_pattern_data_loop

@get_pattern_end:
  ; Pull y, which is our order list index, off the stack, increment it so we
  ; can look at the next item in the sorted order list array
  ply
  iny
  ; Keep looping until we rollover (meaning we've been through all 256 orders)
  bne @get_pattern_loop

; Finally store a $00 to indicate there are no more patterns
; when we load the file back later. This avoids having to track the number
; of patterns in the file.
@write_patterns_end:
  lda #$00
  jsr CHROUT

; Close the file and return
@close_file:
  lda #FILE_NUMBER
  jsr CLOSE
  jsr CLRCHN
  rts
.endproc
