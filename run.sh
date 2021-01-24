#!/bin/bash

ROM="rom.bin"
SCALE=2

#./x16emu -rom $ROM -scale $SCALE -prg $1 -run -debug ea
./x16emu -rom $ROM -scale $SCALE -prg $1 -run -debug -dump R
#./x16emu -rom $ROM -scale $SCALE -prg $1 -debug -dump R
#../x16-emulator/x16emu -rom $ROM -scale $SCALE -prg $1 

