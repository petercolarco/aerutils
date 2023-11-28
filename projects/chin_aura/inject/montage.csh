#!/bin/tcsh
# Merge some files together

  foreach file (`\ls -1 c48R_H40_aura.tavg3d_aer_p.13km.*png`)

   set datestr = `echo $file:r:e`
   echo $datestr
   montage c48R_H40_aura.tavg3d_aer_p.??km.$datestr.png \
           -tile 4x2 -geometry +0+0 c48R_H40_aura.tavg3d_aer_p.$datestr.png

  end
