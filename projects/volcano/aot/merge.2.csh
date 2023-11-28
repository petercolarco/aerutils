#!/bin/csh

# append figures to make a couple of master figures

  foreach volc (NHL NML TRO STR SML SHL)

   convert VM${volc}jan_jul.png VM${volc}apr_oct.png \
           +append VM${volc}.png

  end

  convert VMNHL.png VMNML.png VMTRO.png -append NH.png
  convert VMSTR.png VMSML.png VMSHL.png -append SH.png

end
