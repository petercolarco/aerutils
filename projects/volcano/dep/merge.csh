#!/bin/csh

# append figures to make a couple of master figures

  foreach mon (jan apr jul oct)

  convert VMTRO${mon}.horz_wetdep.png VMNML${mon}.horz_wetdep.png \
          VMNHL${mon}.horz_wetdep.png +append VM.wetdep.${mon}.1.png
  convert VMSTR${mon}.horz_wetdep.png VMSML${mon}.horz_wetdep.png \
          VMSHL${mon}.horz_wetdep.png +append VM.wetdep.${mon}.2.png

  convert VMTRO${mon}.horz_drydep.png VMNML${mon}.horz_drydep.png \
          VMNHL${mon}.horz_drydep.png +append VM.drydep.${mon}.1.png
  convert VMSTR${mon}.horz_drydep.png VMSML${mon}.horz_drydep.png \
          VMSHL${mon}.horz_drydep.png +append VM.drydep.${mon}.2.png

  end

  convert VM.drydep.jan.1.png VM.drydep.jul.2.png \
          VM.drydep.apr.1.png VM.drydep.oct.2.png \
          VM.drydep.jul.1.png VM.drydep.jan.2.png \
          VM.drydep.oct.1.png VM.drydep.apr.2.png \
          drydep_key.png  -append drydep.png

  convert VM.wetdep.jan.1.png VM.wetdep.jul.2.png \
          VM.wetdep.apr.1.png VM.wetdep.oct.2.png \
          VM.wetdep.jul.1.png VM.wetdep.jan.2.png \
          VM.wetdep.oct.1.png VM.wetdep.apr.2.png \
          wetdep_key.png  -append wetdep.png
