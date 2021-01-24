Non-Envelope Slides
===================

These include volume slide, pitch slide, tremolo, vibrato.

Volume Slides (Axx, Bxx)
------------------------

This assumes that we do not have to account for the logarithmic nature of
how actual sound volume works. As in a value of 32 is about half the
audible volume of 64.

A volume slide (Axy in Famitracker-land; Dxy in Impulse Tracker). This does
not require use of an envelope wherein we slide the volume up or down by
the value. Programmatically this affect the volume by the provided value per
tick. Here tick is ill-defined but will probably be associated with VBLANK?

So, for a volume slide down (Bxx), we subtract xx from the current value
until we hit zero. For a volume slide, we do the opposite up to max volume
(63).

This will have to be handled differently between YM2151 and PSGs since the
YM2151 has a wider volume range than VeraSound.

Pitch Slides (Cxy, Dxy)
-----------------------

Like the volume slide, but operates on pitch which is a 16-bit value and
where we include a shift (x). We first add or subject the value of y,
then bit shift the result by x. So if x is zero, no shifts, if x is 1, one
bit-shift left or right, etc.

Tremolo (Txy)

Raise and lower the volume by y with a speed of x. x would be a constant we
are adding or subtracting to the volume on every tick.

TBD: Since we have

This will have to be handled differently between YM2151 and PSGs since the
YM2151 has a wider volume range than VeraSound.
