setup:

  lda #$00
  sta VERA_ctrl ; Select primary VRAM address
  sta VERA_addr_med ; Set primary address med byte to 0
  sta VERA_addr_low ; Set Primary address low byte to 0
  lda #$00
  sta VERA_addr_high ; Set primary address bank to 0, stride to 0
  ;lda #RES128x128x256    ; L0 is the pattern scroll space
  lda #RES128x128x16      ; L0 is the pattern scroll space
  sta VERA_L0_config
  lda #RES128x64x16
  sta VERA_L1_config    ; L1 is the UI
  ; enables 2nd layer (which is currently busted)
  lda #DC_VIDEO
  sta VERA_dc_video
  lda #$80              ; $10000 (start of HiRAM)
  sta VERA_L0_mapbase
  lda #$00
  sta VERA_L1_mapbase

  ; Load the default character tiles on layer 0 (the pattern layer)
  lda #$7C
  sta VERA_L0_tilebase

  sta r0
  lda #$F0
  sta r1
  jsr clear_vram

  ; Clear high VRAM
  lda #$01
  sta VERA_addr_high
  lda #$00
  sta r0
  lda #$F0
  sta r1
  jsr clear_vram
  lda #$00
  sta VERA_addr_high

  jsr vera_load_palette_16

  ; Enable VBLANK Interrupt
  ; We will use VBLANK from the VERA as our time keeper, so we enable
  ; the VBLANK interupt
  lda #VBLANK_MASK
  sta VERA_ien

  rts
