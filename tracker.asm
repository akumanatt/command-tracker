; Core tracker engine routines

.scope tracker
  .include "library/tracker/get_next_pattern.asm"
  .include "library/tracker/get_pattern.asm"
  .include "library/tracker/clear_patterns.asm"
  .include "library/tracker/get_row.asm"
  .include "library/tracker/inc_row.asm"
  .include "library/tracker/play_row.asm"
  .include "library/tracker/stop_song.asm"
  .include "library/tracker/save_song.asm"
  .include "library/tracker/load_song.asm"
  .include "library/tracker/irq.asm"
  .include "library/tracker/exit.asm"
  .scope modules
    .include "library/tracker/modules/help.asm"
    .include "library/tracker/modules/psg_instruments.asm"
    .include "library/tracker/modules/orders.asm"
    .include "library/tracker/modules/play_song.asm"
    .include "library/tracker/modules/edit_pattern.asm"
    .include "library/tracker/modules/save_song.asm"
  .endscope

.endscope
