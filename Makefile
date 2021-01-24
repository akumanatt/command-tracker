all:

#	cl65 -t cx16 -o BOX.PRG -l box.list box.asm
#	cl65 -t cx16 -o DRAWCHARS.PRG -l drawchars.list drawchars.asm
	cl65 -t cx16 -o PLAYSONG.PRG -l playsong.list playsong.asm
#	cl65 -t cx16 -o SCRATCH.PRG scratch.asm


clean:
	rm -f *.prg disk.d64 *.PRG *.o *.list
