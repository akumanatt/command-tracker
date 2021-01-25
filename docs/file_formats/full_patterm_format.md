Full Pattern Format
-------------------

This is a simplified non-sparse (full) format definition. The sparse
format could still be preferable for file storage and for playback only
scenarios (e.g. in a game) where saving RAM is important.

Currently, unlike the proposed sparse format, this format only supports one
effect per channel and only 64 row patterns. This keeps the size
down to just under 8k so that each pattern can fit into a single page
of hiram. This does allow the option for 255 effects though so macros
could be one way around a single effect definition.

Because the size is fixed, we do not need to store row or channel counts.

Each row is, in order, the following:

```
PSG NOTES [CHANNEL 0-15, VeraSound 1-16]
5 bytes

| Note : Inst | Pan    : Vol    | Next Effect Flag : Effect # : Effect Data |
| Byte : Byte | 2-bits : 6-bits | Unused           : 7-bits   : Byte        |

FM NOTES [CHANNEL 16-23, FM 1-8]
5 bytes
| Note : Inst | Volume          | Next Effect Flag : Effect # : Effect Data |
| Byte : Byte | 8-bits          | Unused           : 7-bits   : Byte        |

DPCM NOTES [CHANNEL 24, PCM]
2 bytes
| Note  : | Vol    : Effect |
| Byte  : | Nibble : Nibble |
```

Thus each row is 122 bytes in length and at fixed 64 rows, this ends up being
7808 bytes per pattern.

Note Values
===========

Notes are broken up into nibbles. The top nibble is the octave, and the bottom
the note. So for instance F#4 would be $47.

```
Note Nibble Values:
0 = C
1 = C#
2 = D
3 = D#
4 = E
5 = F
6 = F#
7 = G
8 = G#
9 = A
A = A#
B = B
C = <Reserved>
D = Release
E = Off
F = Noop
```
