; For drawing a box frame:
; algo: draw it like you'd draw it...go across, at end, go down, at end, go back, at end go up
; Thoughts:
; Set origin X/Y
; Then width and height
; Start at top left, draw corner
; Loop drawing lines until X-1
; At X, draw corner
; Draw downward until Y-1
; At Y, draw corner
; draw backwards (cuonting down) until X-1
; draw corner
; draw backwards (counting down) until Y-1
.proc draw_frame
  BOX_X = r0
  BOX_Y = r1
  X_LEN = r2
  Y_LEN = r3
.endproc




.proc clear_screen
  CLEAR = $93 ; PETSCI value to clear the screen
  clear_screen:
     ; set background color in a dirty manner (we did not hear that from Greg King)
     ; https://www.commanderx16.com/forum/index.php?/topic/469-change-background-color-using-vpoke/&do=findComment&comment=3084
     lda #$01
     sta $376
     lda #CLEAR
     jsr CHROUT
     rts
.endproc

; Draw a line of hearts
; a = length, x,y = x/y screen coords
.proc draw_line
  ; Vars for draw_line
  HEART = $53
  LENGTH = r11
  COLOR = r4
  draw_line:
    sta LENGTH
    txa
    asl
    sta VERA_addr_low
    sty VERA_addr_med
    ldx 0
  @loop:
    lda #HEART
    sta VERA_data0 ; Write chracter
    lda #COLOR
    sta VERA_data0 ; Write color
    inx
    cpx LENGTH
    bne @loop
    rts
.endproc

; Draw a solid box
.proc draw_solid_box
  BOX_X = r0
  BOX_Y = r1
  BOX_X_LEN = r2
  BOX_Y_LEN = r3
  COLOR = r4
  COUNT_Y = r6
  BOX_Y_END = r7

  draw_solid_box:
    lda #$0
    sta COUNT_Y
  loopy:
    lda BOX_X_LEN
    ldx BOX_X
    ldy BOX_Y
    jsr draw_line
    inc COUNT_Y
    inc BOX_Y
    ldy COUNT_Y
    cpy BOX_Y_LEN
    bne loopy
    rts
.endproc
