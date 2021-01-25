; Clear VRAM
; Clear VRAM in 255 (low address) chunks
; a = med address start
; x = med address end
.proc clear_vram
  START = r0
  END = r1
clear_vram:
  vera_stride #$10

  lda START
@loop:
  sta VERA_addr_med
  jsr clear_vram_low
  cmp END
  beq @done
  adc #$01
  jmp @loop
@done:
  rts

; Clear all low address range of VRAM
clear_vram_low:
  pha
  ldx #$FF
  lda #$00
  sta VERA_addr_low ; Set Primary address low byte to 0
@loop:
  sta VERA_data0
  sta VERA_data0
  dex
  beq @done
  jmp @loop
@done:
  pla
  rts
.endproc
