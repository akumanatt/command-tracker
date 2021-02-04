; Core tracker engine routines

.scope tracker
  .include "library/tracker/get_next_pattern.asm"
  .include "library/tracker/get_pattern.asm"
  .include "library/tracker/load_patterns.asm"
  .include "library/tracker/get_row.asm"
  .include "library/tracker/inc_row.asm"
  .include "library/tracker/play_row.asm"
  .include "library/tracker/stop_song.asm"
  .include "library/tracker/irq.asm"
  .scope modules
    .include "library/tracker/modules/orders.asm"
    .include "library/tracker/modules/play_song.asm"
  .endscope

.endscope
