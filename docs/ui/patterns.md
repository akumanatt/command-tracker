Sample Pattern View
===================

This is a simple idea for how the patterns (channel) view would work given
there are 3 sound engines at play (PSG, FM, DPCM).

Since there's so many channels and comparatively small real-estate, channels
can be collapsed, skipped, or hidden. As well as having a means to move left
and right across the pattern (perhaps by TAB and SHIFT-TAB as well as arrow
keys).

Similarly, since there can be currently up to 7 effects, the channels can
be expanded as far out as needed. If you see a > below the channel name, it
means there is items that are being hidden (such as effects).

On the note of effects, while some trackers, such as FamiTracker, let you
arrange multiple effects in any order, due to how the sparse format works,
you must always use the first effect column first, followed by the second,
etc. In other words, you cannot have gaps.

The ^^^ and --- are special "notes" to indicate note release and note-off.

Note that in the sparse format, the pan, volume, and effect columns are
optional. This means you can have rows which only modify the volume or
effects for in-pattern automation (instead of using envelopes, for example).

V   = VeraSound
F   = YM2151
PCM = DPCM

```
   | VeraSound 01         | V02    | ... | F1  | FM 2          | ... | PCM |
## | -------------------- | -->    |     | --> | ------------- |     | --> |
00 | ... .. .. .. ... ... | C-1 02 |     | G-3 | D#2 01 FF M01 |     | C-4 |
01 | ... .. .. .. ... ... | C-1 03 |     | ... | ... .. .. ... |     | ... |
02 | C-4 01 .. .. A37 ... | D#1 02 |     | ... | ... .. .. ... |     | ... |
03 | ... .. .. 20 ... ... | D-1 02 |     | ... | ... .. 50 ... |     | ... |
04 | D#4 01 L. 20 A00 V10 | D#1 03 |     | D#3 | ^^^ .. .. ... |     | ... |
05 | D#4 01 .R 10 D04 V1A | G-1 03 |     | ... | ... .. .. D0A |     | ... |
06 | --- .. .. .. ... ... | D#1 02 |     | ... | ... .. .. ... |     | ... |
...
06 | ... .. .. .. ... ... | C-1 .. |     | ... | ... .. .. ... |     | ... |
