Some ideas for getting fancy to save space, but may complicate things. This was also before the SAA1099 was replaced by VERASound:

Variable Length Patterns
------------------------

If a channel is empty, we don't need to store any instrument/vol/effect info
which can save a lot of space, especially for FM instruments and enable more
complicated patterns (such as multiple effects per channel/row ala Deflemask)

However, this could complicate how to jump to a certain row in a pattern since
with fixed length patterns, that's just an offset. But here there is no
fixed offset.

Multiple Effects
----------------

Volume Column Sharing:
This can be done in a few ways. Impulse Tracker included some simple effects
in the volume column, and given the 2151 goes up to 7F we can use the rest
for these at least on the FM side.

Multiple Effect Columns:
Also Famitracker, Deflemask, and others allow for multiple effects per channel.
If we make this fixed for the pattern or song, then we know how many more
bytes to read for a pattern to process the effects.

Macros/Tables:
If we want to keep things to 1 volume column / 1 effect columne, using the
unused effect space for macros/tables would get around the effect limitation
while optimizing pattern data space.

This may also allow us to remove the volume column entirely and treat it
as an effect, but would require more macro work (e.g. if wanting to
set a volume and do a pitch slide)

Define Channels Used
--------------------
If only a subset of channels are used, we only need to store pattern/channel
data for those channels since the others would be just empty space.

DPCM
----
DPCM may need to store data in himem as well, but that would be a good place
for pattern data (for the tracker - for exporting the music to be used for
a game there may need to be a game specific format). This means we may need
to read DPCM data from himem.

I think the answer to this may be a pattern buffer, where the current (and
perhaps next) pattern is stored in lomem.
