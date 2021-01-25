; a = xpos
; y = ypos

.proc vera_goto_xy
vera_goto_xy:
    asl
    sta VERA_addr_low
    tya
    sta VERA_addr_med
    rts
.endproc
