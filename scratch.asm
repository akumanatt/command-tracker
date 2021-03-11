; The main application which is responsible for calling different modules

.include "includes.inc"

; Con
start:
  jsr setup
main:

  ;jsr tracker::save_song
  ;jsr tracker::load_song
  jsr concerto_synth::initialize
  jsr concerto_synth::activate_synth


;              channel number: r0L
;              note timbre:    r0H
;              note pitch:     r1L
;              note volume:    r1H

  sei
   stx concerto_synth::note_pitch
   lda #63
   sta concerto_synth::note_volume
   lda #0
   sta concerto_synth::note_channel
   lda #0
   sta concerto_synth::note_timbre
   sei
   jsr concerto_synth::play_note
   cli


loop:
  sei

  jsr concerto_synth::voices::play_note
  cli
  jmp loop



.include "data.inc"
