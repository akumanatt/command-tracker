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

```
VERSION: 1 byte
SPEED: 1 byte
TEMPO: 1 byte
TITLE: Null Terminated String
ARTIST: Null Terminated String
DESCRIPTION: Null Terminated String
ORDER LIST: Array of patterns to play in order, terminated by 0xFF

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
