; a = xpos
; y = ypos

.proc goto_xy
goto_xy:
    asl
    sta VERA_addr_low
    tya
    sta VERA_addr_med
    rts
.endproc
