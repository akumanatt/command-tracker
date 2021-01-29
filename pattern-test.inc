;pattern_using_tracker_notes:
; note, inst, vol,eff,eff-val
pattern1:
.byte   $42, $01, $20,$10,$00      ; row 0
.byte   $45, $01, $25,$AF,$00      ; row 1
.byte   $49, $01, $2A,$0A,$00      ; row 2
.byte   $52, $01, $35,$0D,$00
.byte   $42, $01, $3F,$FF,$00
.byte   $FF, $01, $05,$FF,$00
.byte   $FF, $01, $3F,$FF,$00
.byte   $FF, $01, $05,$FF,$00
.byte   $FF, $01, $3F,$FF,$00
.byte   $FF, $01, $05,$FF,$00
.byte   $FF, $01, $3F,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00    ; row 16
.byte   $42, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00      ; row 32
.byte   $42, $01, $20,$FF,$00
.byte   $45, $01, $25,$FF,$00
.byte   $49, $01, $2A,$FF,$00
.byte   $52, $01, $35,$FF,$00
.byte   $42, $01, $3A,$FF,$00
.byte   $FF, $01, $40,$FF,$00
.byte   $49, $01, $3A,$FF,$00
.byte   $FF, $01, $39,$FF,$00
.byte   $52, $01, $10,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00    ; row 48
.byte   $45, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00  ; row 63

pattern2:
.byte   $52, $01, $20,$10,$00      ; row 0
.byte   $55, $01, $25,$AF,$00      ; row 1
.byte   $59, $01, $2A,$0A,$00      ; row 2
.byte   $52, $01, $35,$0D,$00
.byte   $52, $01, $3F,$FF,$00
.byte   $FF, $01, $05,$FF,$00
.byte   $FF, $01, $3F,$FF,$00
.byte   $FF, $01, $05,$FF,$00
.byte   $FF, $01, $3F,$FF,$00
.byte   $FF, $01, $05,$FF,$00
.byte   $FF, $01, $3F,$FF,$00
.byte   $62, $01, $FF,$FF,$00
.byte   $59, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00    ; row 16
.byte   $42, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00      ; row 32
.byte   $42, $01, $20,$FF,$00
.byte   $45, $01, $25,$FF,$00
.byte   $49, $01, $2A,$FF,$00
.byte   $52, $01, $35,$FF,$00
.byte   $42, $01, $3A,$FF,$00
.byte   $FF, $01, $40,$FF,$00
.byte   $49, $01, $3A,$FF,$00
.byte   $FF, $01, $39,$FF,$00
.byte   $52, $01, $10,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00    ; row 48
.byte   $45, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00  ; row 63

pattern3:
.byte   $62, $01, $20,$10,$00      ; row 0
.byte   $62, $01, $25,$AF,$00      ; row 1
.byte   $62, $01, $2A,$0A,$00      ; row 2
.byte   $62, $01, $35,$0D,$00
.byte   $62, $01, $3F,$FF,$00
.byte   $62, $01, $05,$FF,$00
.byte   $62, $01, $3F,$FF,$00
.byte   $62, $01, $05,$FF,$00
.byte   $62, $01, $3F,$FF,$00
.byte   $62, $01, $05,$FF,$00
.byte   $62, $01, $3F,$FF,$00
.byte   $72, $01, $FF,$FF,$00
.byte   $69, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $62, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00    ; row 16
.byte   $62, $01, $FF,$FF,$00
.byte   $65, $01, $FF,$FF,$00
.byte   $69, $01, $FF,$FF,$00
.byte   $62, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00      ; row 32
.byte   $42, $01, $20,$FF,$00
.byte   $45, $01, $25,$FF,$00
.byte   $49, $01, $2A,$FF,$00
.byte   $52, $01, $35,$FF,$00
.byte   $42, $01, $3A,$FF,$00
.byte   $FF, $01, $40,$FF,$00
.byte   $49, $01, $3A,$FF,$00
.byte   $FF, $01, $39,$FF,$00
.byte   $52, $01, $10,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FD, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00    ; row 48
.byte   $45, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FF, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00
.byte   $52, $01, $FF,$FF,$00
.byte   $49, $01, $FF,$FF,$00
.byte   $FE, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $45, $01, $FF,$FF,$00  ; row 63

pattern4:
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
.byte   $42, $01, $FF,$FF,$00
