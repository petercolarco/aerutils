#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/MISR/Level3/GRITAS

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
      $gfiomean -vars AODTAU -o ./misr_clim_2000_2003_${mm}_pete.hdf \
                      $inpDir/Y2003/M${mm}/misr.aero.2003${mm}.hdf $inpDir/Y2002/M${mm}/misr.aero.2002${mm}.hdf \
                      $inpDir/Y2001/M${mm}/misr.aero.2001${mm}.hdf $inpDir/Y2000/M${mm}/misr.aero.2000${mm}.hdf 

  end


