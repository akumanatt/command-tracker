File Format
-----------

This is an overview of the file storage format. There's quite a few moving
pieces here so be sure to look at the other sections in the table of contents.

In general, section terminators are defined by 0xFF. This means the total
count of some things (like total number of patterns) is 127 not 128.

This defines the file format on disk. In reality some of these items might
be handled differently. It might be easier, for instance, to have static
arrays for the title and artist and load description into a string say
on some random page of RAM or something (or don't load it at all unless
requested and read it from the file at that point).

*The most basic and wasteful format:*

Here we are storing all data, regardless of if it was used or not. For instance,
we store all the pages in himem instead of looking to see which patterns are
actually used and storing only those. But this works for now.

```
ADDRESS HEADER: 2 bytes (Unused)
VERSION: 1 byte
SPEED: 1 byte
TITLE: 16 bytes
ARTIST: 16 bytes
ORDER LIST: 255 bytes
PATTERNS: $1F40 bytes * $FE pages

```
*Old/future format*

```
ADDRESS HEADER: 2 bytes (Unused)
VERSION: 1 byte
SPEED: 1 byte
TITLE: 0 terminated string
ARTIST: 0 terminated string
ORDER LIST: orders, terminated by FF
PATTERNS:



VERASOUND INSTRUMENT DATA:
  INST #: 0x00-0xFE
  INST NAME: Null Terminated String
  INITIAL WAVEFORM / PWM: 1 byte
  VOLUME ENVELOPE: 1 byte, 0xFF for none
  PITCH ENVELOPE: 1 byte, 0xFF for none
  PWM ENVELOPE: 1 byte, 0xFF for none
  ... (still TBD)
END OF VERASOUND INSTRUMENTS: 0xFF

FM INSTRUMENT DATA:
  INST #: 0x00-0xFE
  INST NAME: Null Terminated String
  ... Data format TBD
END OF FM INSTRUMENTS: 0xFF

PCM INSTRUMENT DATA:
  INST #: 0x00-0xFE
  INST NAME: Null Terminated String
  ... Data format TBD
END OF PCM INSTRUMENTS: 0xFF

ENVELOPES:
  ENV #: 0x00-0xFE
  DATA FORMAT: TBD (see effects/envelopes)

SPARSE PATTERN DATA:
  PATTERN #: [0x00-0xFE]
    Sparse Pattern Data (see file_formats/sparse_format)
  ...
  0xFF: End of Patterns Marker
```
