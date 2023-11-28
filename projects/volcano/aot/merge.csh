#!/bin/csh

# append figures to make a couple of master figures

  foreach volc (NHL NML TRO STR SML SHL)

   convert VM${volc}jan.horz.png VM${volc}apr.horz.png \
           VM${volc}jul.horz.png VM${volc}oct.horz.png \
           +append VM${volc}.horz.png

  end

  convert VMNHL.horz.png VMNML.horz.png VMTRO.horz.png -append NH.horz.png
  convert VMSTR.horz.png VMSML.horz.png VMSHL.horz.png -append SH.horz.png

end
