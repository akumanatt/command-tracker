.CODE
setup:
  stz VERA_ctrl ; Select primary VRAM address
  stz VERA_addr_med ; Set primary address med byte to 0
  stz VERA_addr_low ; Set Primary address low byte to 0
  stz VERA_addr_high ; Set primary address bank to 0, stride to 0

  ;lda #RES128x128x256    ; L0 is the pattern scroll space
  lda #RES128x128x16      ; L0 is the pattern scroll space
  ;lda #RES128x256x16      ; L0 is the pattern scroll space
  ;lda #RES128x128x256    ; L0 is the pattern scroll space
  sta VERA_L0_config
  lda #RES128x64x16
  sta VERA_L1_config    ; L1 is the UI
  ; enables 2nd layer
  lda #DC_VIDEO
  sta VERA_dc_video
  lda #$80              ; $10000 (start of HiRAM)
  sta VERA_L0_mapbase
  stz VERA_L1_mapbase

  ; Load the default character tiles on layer 0 (the pattern layer)
  lda #$7C
  sta VERA_L0_tilebase

  ;sta r0
  stz r0
  lda #$F0
  ;lda #$F6
  sta r1
  jsr graphics::vera::clear_vram

  ; Clear high VRAM
  lda #$01
  sta VERA_addr_high
  stz r0
  lda #$F0
  sta r1
  jsr graphics::vera::clear_vram
  stz VERA_addr_high

  jsr graphics::vera::load_palette_16

  ; Set ROM Bank to 0 (Kernel)
  ; This speeds up calls to kernel routines by avoiding unnecessary jumps
  ; when using the default ROM bank (4) which is for BASIC and we don't need
  ; here.
  stz ROM_BANK

  ; Enable VBLANK Interrupt
  ; We will use VBLANK from the VERA as our time keeper, so we enable
  ; the VBLANK interupt
  lda #VBLANK_MASK
  sta VERA_ien

  ; Set state to 0 (idle/stopped)
  stz STATE

  ; Set start channel to 0
  stz START_CHANNEL

  ; Set pattern pointer
  lda #<PATTERN_ADDRESS
  sta PATTERN_POINTER
  lda #>PATTERN_ADDRESS
  sta PATTERN_POINTER + 1

  ; Start at first pattern
  lda #$01
  sta PATTERN_NUMBER

  ; Manully set speed (for now)
  lda #$03
  sta SPEED

  jsr tracker::clear_patterns


  jsr concerto_synth::initialize
  CONCERTO_LOAD_FACTORY_PRESETS
  ;jsr concerto_synth::activate_synth

  rts
