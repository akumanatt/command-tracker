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

```
Special Notes:
FD: Note Release
FE: Note Off
FF: Null

Standard Notes:

00: Note C-0
01: Note C#0
02: Note D-0
03: Note D#0
04: Note E-0
05: Note F-0
06: Note F#0
07: Note G-0
08: Note G#0
09: Note A-0
0A: Note A#0
0B: Note B-0

0C: Note C-1
0D: Note C#1
0E: Note D-1
0F: Note D#1
10: Note E-1
11: Note F-1
12: Note F#1
13: Note G-1
14: Note G#1
15: Note A-1
16: Note A#1
17: Note B-1

18: Note C-2
19: Note C#2
1A: Note D-2
1B: Note D#2
1C: Note E-2
1D: Note F-2
1E: Note F#2
1F: Note G-2
20: Note G#2
21: Note A-2
22: Note A#2
23: Note B-2

24: Note C-3
25: Note C#3
26: Note D-3
27: Note D#3
28: Note E-3
29: Note F-3
2A: Note F#3
2B: Note G-3
2C: Note G#3
2D: Note A-3
2E: Note A#3
2F: Note B-3

30: Note C-4
31: Note C#4
32: Note D-4
33: Note D#4
2F: Note E-4
30: Note F-4
31: Note F#4
32: Note G-4
33: Note G#4
34: Note A-4
35: Note A#4
36: Note B-4

37: Note C-5
38: Note C#5
39: Note D-5
3A: Note D#5
3B: Note E-5
3C: Note F-5
3D: Note F#5
3E: Note G-5
3F: Note G#5
40: Note A-5
41: Note A#5
42: Note B-5

43: Note C-6
44: Note C#6
45: Note D-6
46: Note D#6
47: Note E-6
48: Note F-6
49: Note F#6
4A: Note G-6
4B: Note G#6
4C: Note A-6
4D: Note A#6
4E: Note B-6

4F: Note C-7
50: Note C#7
51: Note D-7
52: Note D#7
53: Note E-7
54: Note F-7
55: Note F#7
56: Note G-7
57: Note G#7
58: Note A-7
59: Note A#7
5A: Note B-7

5B: Note C-8
5C: Note C#8
5D: Note D-8
5E: Note D#8
5F: Note E-8
60: Note F-8
61: Note F#8
62: Note G-8
63: Note G#8
64: Note A-8
65: Note A#8
66: Note B-8

67: Note C-9
68: Note C#9
69: Note D-9
6A: Note D#9
6B: Note E-9
6C: Note F-9
6D: Note F#9
6E: Note G-9
6F: Note G#9
70: Note A-9
71: Note A#9
72: Note B-9

73: Note C-A
74: Note C#A
75: Note D-A
76: Note D#A
77: Note E-A
78: Note F-A
79: Note F#A
7A: Note G-A
7B: Note G#A
7C: Note A-A
7D: Note A#A
7E: Note B-A

7F: Note C-A
80: Note C#A
81: Note D-A
82: Note D#A
83: Note E-A
84: Note F-A
85: Note F#A
86: Note G-A
87: Note G#A
88: Note A-A
89: Note A#A
8A: Note B-A

8B: Last note

```
