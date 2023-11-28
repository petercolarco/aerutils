#!/bin/csh

# append figures to make a couple of master figures

  foreach volc (NHL NML TRO STR SML SHL)

  foreach mon (jan apr jul oct)

   convert reff_zonal.VM${volc}${mon}01b.60N.png \
           reff_zonal.VM${volc}${mon}01b.30N.png \
           reff_zonal.VM${volc}${mon}01b.00N.png \
           reff_zonal.VM${volc}${mon}01b.30S.png \
           reff_zonal.VM${volc}${mon}01b.60S.png \
           -append reff_zonal.VM${volc}${mon}01b.png
  end

   convert reff_zonal.VM${volc}jan01b.png reff_zonal.VM${volc}apr01b.png \
           reff_zonal.VM${volc}jul01b.png reff_zonal.VM${volc}oct01b.png \
           +append reff_zonal.VM${volc}.png

  end
