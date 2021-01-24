Envelopes
=========

Ideas from a conversation with Stephen Horn on the X16 forums
(https://www.commanderx16.com/forum/index.php?/topic/558-saasound-saa1099-support-in-emulator/#comment-6124)

Envelopes can be of variable width and support loops, including
both forward and ping-pong loops. Since only 6-bits are used for volume
and PWM, we can go ahead and include the LR enable and Waveform select
bits in the envelope steps.

An envelope then consists of a handful of bytes in memory. A 1-3 byte
header (depending on if looping is enabled) and up to 64 steps, which
are a byte each.

Envelopes can then be assigned to either volume, PWM, or even both.

Currently there is no definition for envelope speed. This could be
either controlled by the vblank, game clock, or part of the global
song tempo (like the speed setting of a tracker).

Finding Envelopes
-----------------

One idea was to store the envelopes on a specific RAM bank. Given their
modest storage, the page could also be used for other things as well
more than likely (such as instrument definitions for mapping said
envelopes to instruments, the instruments' default waveform, etc.).

The envelopes themselves can be in a simple look-up-table which starts
with the number of envelopes defined with the next X bytes being pointers
to each envelope's header. If there is a loop defined, the step data is
after the 2 bytes that define the loop parameters. Thus the step info
can be found by offsets.

Envelope Format
---------------

Header:
| 7 | 6 | 5 - 0 |
| - | - | ----- |
| Loop Enable | Loop Type (Forward / Ping-Pong) | Length |

If loop bit is set:

Loop Start:

| 7-6 | 5 - 0 |
| --- | ----- |
| X | Loop Start |

Loop End:

| 7-6 | 5 - 0 |
| --- | ----- |
| X | Loop End |

Steps:

| 7-6 | 5-0 |
| --- | --- |
| L/R or Wave Select | Volume (63-0) |

The steps correspond exactly to the format of the VERA PSG registers
for volume and PWM.

**Example**

1. A simple pluck style envelope with no looping:

```
00000101  ; No loop, Length of 5
11111111  ; LR, Vol 63
11100000  ; LR, Vol 32
11001000  ; LR, Vol 16
11000010  ; LR, Vol 4
11000000  ; LR, Vol 0
```

Since the high byte of the header is 0, there is no loop enabled so we
know the next 5 bytes are the actual envelope data. Both channels are
enabled for all 5 steps since the first two bits are 1's. The remaining
6 bits correspond then to the volume steps.

1. A Tremolo (looping)

```
11000100  ; Loop Enable, Ping-Pong, Length of 4
00000000  ; Start loop at beginning
00000100  ; End loop at end
11111111  ; LR, Vol 63
11100000  ; LR, Vol 32
11010000  ; LR, Vol 8
11001000  ; LR, Vol 4
```

Here we enable the loop and set the type to ping-pong, then set the loop
points in the next two bytes. The next 4 bytes are then envelope itself which somewhat coarsely sets the volume between 63 and 4. Since we have
ping-pong enabled, the envelope will be evaluated "forever" as long as
a note is playing, going from steps 0,1,2,3,2,1,0,1,2,... repeating.
