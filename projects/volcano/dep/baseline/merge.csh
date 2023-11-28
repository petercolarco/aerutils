#!/bin/csh

# append figures to make a couple of master figures

  foreach mon (jan apr jul oct)

  convert VMTRO${mon}.horz_drydep.png VMNML${mon}.horz_drydep.png \
          VMNHL${mon}.horz_drydep.png +append VM.drydep.${mon}.1.png
  convert VMSTR${mon}.horz_drydep.png VMSML${mon}.horz_drydep.png \
          VMSHL${mon}.horz_drydep.png +append VM.drydep.${mon}.2.png

  end

  convert VM.drydep.jan.1.png VM.drydep.jul.2.png \
          VM.drydep.apr.1.png VM.drydep.oct.2.png \
          VM.drydep.jul.1.png VM.drydep.jan.2.png \
          VM.drydep.oct.1.png VM.drydep.apr.2.png \
          -append drydep.png