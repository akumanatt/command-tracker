Effects List
============

Here's a list of all the effects, though details of how the effects work
programmatically will be covered elsewhere. And likewise this may get
broken out a bit since there may be effects that only make sense for FM,
PSG and DPCM. For now here is the full list (but expect this to change)

```
Axy: Arp (x,y are both semitones up from base note)
Bxx: Volume Slide Up (Fade-In)
Cxx: Volume Slide Down (Fade-Out)
Dxx: Delay Note
Exy: Assign Envelope (x = destination; y = envelope #, 0 = disable))
  * PSG Destinations:
    * 0 = Disable Running Envelope
    * 1 = Volume
    * 2 = PWM
    * 3 = Pitch
Fxx: Finetune Pitch (like Famitracker, < 80 pitch down > 80 pitch up)
Gxx: Glissando / Portamento (x = speed)
Jxx: Jump to Pattern
Lxy: Tremolo (x = speed; y = depth)
Mxx: Execute Macro
Nxy: Set Channel Behavior
  * N1x: Set default next note behavior (0 = Note Off, 1 = Note Release) [PSG]
Pxy: Pitch Slide Up (x = coarse; y = fine)
Qxy: Pitch Slide Down (x = coarse; y = fine)
Rxx: Jump to Row ? (not sure on this one - will have to track a loop counter)
Sxx: Global Speed
Txx: Global Tempo
Vxx:
  * For PSG: Set Waveform / PWM
    * 00-1F: Select Squarewave, PWM
    * 20: Select Saw
    * 21: Select Triangle
    * 22: Select Noise
  * For FM: ?
Zxx: Stop Song
```
