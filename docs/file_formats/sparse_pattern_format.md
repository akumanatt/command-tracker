Sparse format derived in part from Ron Hubbard's format for the SID
(http://www.1xn.org/text/C64/rob_hubbards_music.txt)

Because there are so many channels, and optionally effects, storing an entire
song as a full sequence of rows and patterns would require a large amount of RAM.
Given 26 channels, and up to 25 bytes per row, a single row would be 650 bytes!
Thus an entire pattern would be 41.6k! This could become smaller if reducing
the feature-set, such as only support 1 effect per channel (instead of up to 3
or so). However, if we adopt a sparse format, we can dramatically decrease
this requirement in many cases.

This saves storage space at the cost of a more complicated playback routine
and a potentially much more complicated editing routine (e.g. when working
on a pattern in the tracker). For instance, adding new row in the middle
of a sparse pattern would require re-arranging the subsequent patterns.
Or one might be able to use references, at the cost of more RAM. The same
issue happens when adding more channels to a row - all the subsequent
data would need to be shifted over.

The ideal when composing is to have a pattern buffer, but given the channels
and effects, it will likely exceed a single 8k page of RAM.

PATTERN DATA
------------

A pattern is a sequence of sparse row data read up until we read in channel
30 (11110xxx) after the last read channel. Rows are sparse so the first
byte of the pattern could be any row within the pattern, not 00. As we use
a full byte for the row, the max length of a pattern can be 255 rows.

So a sequence might be:

```
16 ..... 31
24 ..... 31
32 .... 31
64 .... 31 32
```

If we read 31 (11111xxx) for the channel (noting channels are the top 5-bits), then
we're at the end of the pattern.

One interesting thing about this is that patterns can be of different lengths
within the same song. In normal trackers the size is usually set. Currently
there is no "pattern length" byte, and I'm wondering if that would be wise.
That is more for the tracker itself, rather than a player, so we don't have
to scan all rows to figure out the total row data. On the other hand, when
we're showing the full pattern, we may have to read this all in anyway
(if we want to use an un-sparse buffer, noting the RAM requirements could be
high).

One trick for displaying the row as a buffer, is to use the VERA's RAM
and store the pattern display of sorts. In reality because of being able
to collapse channels to view more channels, and due to the flexible number
of effects, that might be a bit too complicated. Yet storage an un-sparse
pattern will otherwise require lots of X16 RAM since one pattern can easily
go past a single 8k page.

ROW DATA
--------

Row Number:

Since we are storing only rows which have data in them, the first byte of
the row is the row number. In other words, we are not storing empty rows.
The row number is a full byte so patterns can be up to 255 rows long.


CHANNEL DATA
------------

We only store channel data for channels that are doing something. That something
can be playing a note, changing the volume column, or changing the effects.

The first byte read after the row number is the first channel that has data
that needs to be updated. These should be ordered (smallest channel first)
for sanity sake.

**Channel Format**

This looks a little complicated at first, but isn't too terrible. Space is
paramount in the sparse format, so there's a few tricks in place. First,
let's look at the formats:

(Note for NVE flags, guessing BBSn/BBRn may be useful here, see Matt's video)

```
PSG NOTES [CHANNEL 0-15, VeraSound 1-16]
2-X bytes
                      | If Note Flag Set       | If Vol Flag Set | If Effect Flag Set                        |
Channel : N/V/E Flags | Note   : Octave : Inst | Pan    : Vol    | Next Effect Flag : Effect # : Effect Data |
5-bits  : 3-bits      | Nibble : Nibble : Byte | 2-bits : 6-bits | 1-bit            : 7-bits   : Byte        |

FM NOTES [CHANNEL 16-23, FM 1-8]
2-X bytes
                      | If Note Flag Set       | If Vol Flag Set | If Effect Flag Set                        |
Channel : N/V/E Flags | Note   : Octave : Inst | Volume          | Next Effect Flag : Effect # : Effect Data |
5-bits  : 3-bits      | Nibble : Nibble : Byte | 8-bits          | 1-bit            : 7-bits   : Byte        |

DPCM NOTES [CHANNEL 24, PCM]
3 bytes
                                | If Note Flag Set        | If VE Flag Set  |
Channel : N/VE Flags | Reserved | Note    : Oct/Inst Bank | Vol    : Effect |
5-bits  : 2-bits     | 1-bit    | Nibble  : Nibble        | Nibble : Nibble |

SPECIAL CHANNELS (31 End of Row, 32 End of Pattern)

Channel : Unused
5-bits  : 3-bits

```

**Flags**

The minimum data we need is the channel number and flags. At least one flag
should be set for it to make any sense. N is note, V is volume column, E
is effects (note for DPCM we're only using 2 flags since vol/effect is
combined in a single byte). The order of the flags matters so to map things out:

```
Flags Set:
N--: Next byte is note data
-V-: Next byte is volume data
--E: Next 2 to n bytes are effect data (see below)
N-E: Next byte is note, followed by effect data
NV-: Next byte is note, followed by volume byte
-VE: Next byte is volume, followed by effects
NVE: Next byte note, then volume, then effects.
```

This means, if we are only using notes (no volume or effect changes), we
only need 2 bytes (channel #, flags and note data). Not bad!

But likewise, we might have a case where we aren't changing any notes, but
are manipulating the volume. In that case, we do not set the note and effect
flags but DO set the volume flag. That means the next byte after the flags
is the volume byte. In total, we only need a total of 2 bytes here also
(channel #, flags, and volume data).

Effects are interesting in that, if the effect-flag is set, we know there
is at least 1 effect so the number of bytes here is at least 3. However when we
read in that effect, there is a next-effect flag. If it is set, we know the
next 2 bytes would be another effect. This means that by the format definition,
a channel can have any number of effects (but surely this will be practically
limited).

Likewise, 127 effects is A LOT, especially since the raw values can be
dependent VeraSound, FM, or DPCM. This means there's the potential for taking
another bit (maybe even two) away to be used for flags or something else.

In reality what may happen is the Exx and Mxx (Envelope and Macro) affects
may get mapped to the higher values internally. So if there are, say, 16
defined effects, 17-128 can be used for the Exx and Mxx. So say 17-64
is for Envelope assignemnt and the rest are for Macros. Something like that
(this needs to be further fleshed out).

**Channel Number Mapping**

0-15:   VeraSound
16-23:  FM
24:     DPCM
25-29:  Reserved
30:     End of Row Marker
31:     End of Pattern Marker

Normally, if we're using a defined channel, the last 3-bits are for flags
(for DPCM the last bit is currently unused) followed by row data.

However, if the channel number is 31 or 32, we only have to read that one
byte as these signify end of row and end of pattern respectively.

**Note Values**

Since we have 16 values for notes, but only 12 semitones per octave, the
other 4 values are for special cases (such as NULL (effect only), NOTE OFF).
For DPCM the note and octave select which sample is to be played.
In reality this may be more than needed since it can take several CPU cycles to
load in a new sample to the point this may not be able to be done in "realtime"
while a song is playing. Doubly so when playing songs within a game instead of
the dedicated tracker.

```
Special Note Values:

0: Null (Likely not used with sparse format - no need?)
1: Note A
2: Note A#
3: Note B
4: Note C
5: Note C#
6: Note D
7: Note D#
8: Note E
9: Note F
A: Note F#
B: Note G
C: Note G#
D:
E: Note Release
F: Note OFF
```

**Note if the note is E or F, it means we can skip the instrument byte.**

DPCM:

DPCM is special. We have fewer options here so the 3-bits is now just a
flag as to whether there is a vol/effect byte at the end or not. Likewise
the "notes" will correspond to a sample (much like the NES) though this
needs to be further thought out as there may be CPU limitations at play to
fill the audio buffer in time when switching samples.

**Previous Row Data Definition**

The above has already been covered but only for VeraSound. This is here for
future work to update the

```
Row Number : Byte

PSG NOTES [CHANNEL 0-15, VeraSound 1-16]
2-X bytes
                      | If Note Flag Set       | If Vol Flag Set | If Effect Flag Set                        |
Channel : N/V/E Flags | Note   : Octave : Inst | Pan    : Vol    | Next Effect Flag : Effect # : Effect Data |
5-bits  : 3-bits      | Nibble : Nibble : Byte | 2-bits : 6-bits | 1-bit            : 7-bits   : Byte        |


PSG Effect Only:
2-16 bytes
                                       | Optional (defined by EFX Count) |
Channel : # Effects  : Note    : Octave | Pan    : Vol    : Effect       |
5-bits  : 3-bits     : xE      : 0      | 2-bits : 6-bits : 0-14 Bytes   |



FM NOTES [CHANNEL 16-23, FM 1-8]
3-11 bytes
                                                     | Optional (defined by EFX Count)  |
Channel : # Effects  : Note    : Octave : Instrument | Vol  : Effect                    |
5-bits  : 3-bits     : Nibble  : Nibble : Byte       | Byte : 0-14 Bytes                |

DPCM NOTES [CHANNEL 24, PCM]
3 bytes
Channel : Vol/EFX Flags : Note    : Oct/Inst Bank : Vol    : Effect
5-bits  : 3-bits        : Nibble  : Nibble        : Nibble : Nibble

End of Row: Byte (11110xxx, e.g Channel 32)

...

End of Pattern: Byte (11111xxx, e.g. Channel 32)

```
