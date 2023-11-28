#!/bin/csh

# append figures to make a couple of master figures

  foreach volc (NHL NML TRO STR SML SHL)

   convert VM${volc}jan.ext.png VM${volc}apr.ext.png \
           VM${volc}jul.ext.png VM${volc}oct.ext.png \
           +append VM${volc}.ext.png

  end

  convert VMNHL.ext.png VMNML.ext.png VMTRO.ext.png -append NH.ext.png
  convert VMSTR.ext.png VMSML.ext.png VMSHL.ext.png -append SH.ext.png

end
