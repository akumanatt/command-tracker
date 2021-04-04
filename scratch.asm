; The main application which is responsible for calling different modules

;.zeropage
;.include "zeropage.asm"
;.include "concerto_synth/synth_zeropage.asm"

.include "library/preamble.asm"


;.include "includes.inc"

; Zero Page
RAM_BANK          = $00
ROM_BANK          = $01
ADDRESS = $30
NUM_BYTES = $32

TEMP1 = $40
TEMP2 = $42
TEMP3 = $44
TEMP4 = $46
TEMP5 = $48
TEMP6 = $4A

MEMORY_FILL                   := $FEE4

; I/O Registers
VERA_addr_low     = $9F20
VERA_addr_med		  = $9F21
VERA_addr_high    = $9F22
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25
VERA_ien          = $9F26
VERA_isr          = $9F27
VERA_irqline_l    = $9F28
VERA_dc_video     = $9F29
VERA_dc_hscale    = $9F2A
VERA_dc_vscale    = $9F2B
VERA_dc_border    = $9F2C
VERA_dc_hstart    = $9F29
VERA_dc_hstop     = $9F2A
VERA_dc_vsstart   = $9F2B
VERA_dc_vstop     = $9F2C
VERA_L0_config    = $9F2D
VERA_L0_mapbase   = $9F2E
VERA_L0_tilebase  = $9F2F
VERA_L0_hscroll_l = $9F30
VERA_L0_hscroll_h = $9F31
VERA_L0_vscroll_l = $9F32
VERA_L0_vscroll_h = $9F33
VERA_L1_config    = $9F34
VERA_L1_mapbase   = $9F35
VERA_L1_tilebase  = $9F36
VERA_L1_hscroll_l = $9F37
VERA_L1_hscroll_h = $9F38
VERA_L1_vscroll_l = $9F39
VERA_L1_vscroll_h = $9F3A
VERA_audio_ctrl   = $9F3B
VERA_audio_rate   = $9F3C
VERA_audio_data   = $9F3D
VERA_spi_data     = $9F3E
VERA_spi_ctrl     = $9F3F



;PATTERN_ADDRESS_TEST = $A000
PATTERN_ADDRESS_TEST = $A000
HEADER_BACKGROUND_COLOR = $B0
; Field : Sprit E : L1 E : L2 E : NC : Chroma : Output x2
DC_VIDEO = %00110001
RES128x64x256 = %01101000
RES128x128x256  = %10101000
RES128x256x16  = %10111000
RES128x64x16  = %01100000
RES128x128x16  = %10100000

; Change me to adjust the screen drawing issue.
; As you increase this, notice the blank bits on the right side get
; larger.
PAGES_TO_CLEAR = $20

; Con
start:

setup:
  stz VERA_ctrl ; Select primary VRAM address
  stz VERA_addr_med ; Set primary address med byte to 0
  stz VERA_addr_low ; Set Primary address low byte to 0
  stz VERA_addr_high ; Set primary address bank to 0, stride to 0
  lda #RES128x128x16      ; L0 is the pattern scroll space
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

  ; Clear VRAM
  stz TEMP1
  lda #$F0
  sta TEMP2
  jsr clear_vram
  lda #$01
  sta VERA_addr_high
  stz TEMP1
  lda #$F0
  sta TEMP2
  jsr clear_vram
  stz VERA_addr_high

  ; Load Pallette
  jsr load_palette_16

  ; Set ROM Bank to 0 (Kernel)
  ; This speeds up calls to kernel routines by avoiding unnecessary jumps
  ; when using the default ROM bank (4) which is for BASIC and we don't need
  ; here.
  stz ROM_BANK

main:
    ;jsr clear_patterns
    lda #$00
    sta TEMP1
    sta TEMP2
    lda #$51
    sta TEMP3
    ; Y End
    lda #$3C
    sta TEMP4
    lda #HEADER_BACKGROUND_COLOR
    sta TEMP5
   jsr draw_solid_box

loop:
  jmp loop


; Draw a solid box
.proc draw_solid_box
  ; Constants
  ;SPACE = $20
  SPACE = $4F
  ; Vars
  BOX_X = TEMP1
  BOX_Y = TEMP2
  BOX_X_LEN = TEMP3
  BOX_Y_LEN = TEMP4
  COLOR = TEMP5
  ; Temp
  COUNT_Y = TEMP6
  ;BOX_Y_END = r7

draw_solid_box:
    lda #$0
    sta COUNT_Y
  @loopy:
    lda BOX_X_LEN
    ldx BOX_X
    ldy BOX_Y
  @line:
    lda TEMP3
    txa
    asl
    sta VERA_addr_low
    sty VERA_addr_med
    ldx 0
  @line_loop:
    lda #SPACE
    sta VERA_data0 ; Write chracter
    lda COLOR
    sta VERA_data0 ; Write color
    inx
    cpx BOX_X_LEN
    bne @line_loop

@end_line_loop:
    inc COUNT_Y
    inc BOX_Y
    ldy COUNT_Y
    cpy BOX_Y_LEN
    bne @loopy
    rts
.endproc


; Clear VRAM
; Clear VRAM in 255 (low address) chunks
; a = med address start
; x = med address end
.proc clear_vram
  START = TEMP1
  END = TEMP2
clear_vram:
  lda #$10
  sta VERA_addr_high
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
  stz VERA_addr_low
  ;lda #$00
  ;sta VERA_addr_low ; Set Primary address low byte to 0
@loop:
  stz VERA_data0
  stz VERA_data0
  dex
  beq @done
  jmp @loop
@done:
  pla
  rts
.endproc

; Load 16 color palette
.proc load_palette_16
load_palette_16:
  lda #$11
  sta VERA_addr_high
  lda #$FA
  sta VERA_addr_med
  lda #$00
  sta VERA_addr_low
  ldx #$00
@loop:
  lda palette,x
  sta VERA_data0
  inx
  cpx #$20
  bne @loop
  rts
.endproc

clear_patterns:
  ; Fill with empty patterns for now
  ldx #$01
@empty_patterns_loop:
  stx RAM_BANK
  phx
  lda #<PATTERN_ADDRESS_TEST
  sta ADDRESS
  lda #>PATTERN_ADDRESS_TEST
  sta ADDRESS + 1

  lda #$00
  sta NUM_BYTES
  lda #$20
  sta NUM_BYTES + 1

  lda #$FF
  ;jsr MEMORY_FILL
  ;jsr my_memory_fill
  plx
  inx
  ;cpx #$00
  cpx #PAGES_TO_CLEAR
  bne @empty_patterns_loop
  rts


my_memory_fill:

  rts


palette:
.byte $02,$00     ; super dark blue
.byte $FF,$0F     ; white
.byte $00,$0F     ; red
.byte $4F,$04     ; cyan
.byte $04,$0A     ; purple
.byte $D0,$00     ; green
.byte $0F,$00     ; blue
.byte $F0,$0F     ; yellow
.byte $50,$0F     ; orange
.byte $30,$0A     ; brown
.byte $55,$0F     ; light red
.byte $22,$02     ; dark grey
.byte $44,$04     ; grey
.byte $F5,$05     ; light green
.byte $9F,$0A     ; light blue
.byte $88,$08     ; light gray
