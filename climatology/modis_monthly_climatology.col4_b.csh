#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/colarco/MODIS/Level3/b/GRITAS

  foreach type (lnd ocn)

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
      $gfiomean -vars AODTAU -o MOD04_L2_${type}.clim_004_b.2000_2004_${mm}_pete.hdf $inpDir/Y2004/M${mm}/MOD04_L2_${type}.aero_004.2004${mm}.hdf $inpDir/Y2003/M${mm}/MOD04_L2_${type}.aero_004.2003${mm}.hdf $inpDir/Y2002/M${mm}/MOD04_L2_${type}.aero_004.2002${mm}.hdf $inpDir/Y2001/M${mm}/MOD04_L2_${type}.aero_004.2001${mm}.hdf $inpDir/Y2000/M${mm}/MOD04_L2_${type}.aero_004.2000${mm}.hdf 
  end

 end

