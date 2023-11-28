#!/bin/csh

# append figures to make a couple of master figures

  foreach volc (NHL NML TRO STR SML SHL)

   \convert -density 300 VM${volc}.g5.ps VM${volc}.g5.png
   \convert -density 300 VM${volc}.giss.ps VM${volc}.giss.png

   convert VM${volc}.g5.png VM${volc}.giss.png \
           +append VM${volc}.png

  end

  convert VMNHL.png VMNML.png VMTRO.png -append NH.png
  convert VMSTR.png VMSML.png VMSHL.png -append SH.png

end
