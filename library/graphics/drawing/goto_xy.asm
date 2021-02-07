; a = xpos
; y = ypos

.proc goto_xy
goto_xy:
    asl
    sta VERA_addr_low
    ;tya
    sty VERA_addr_med
    rts
.endproc
