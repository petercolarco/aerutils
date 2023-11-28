#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/MODIS/Level3/MYD04/GRITAS

  foreach type (lnd ocn)

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
      $gfiomean -vars AODTAU -o MYD04_L2_${type}.clim_005.2003_2005_${mm}_pete.hdf  $inpDir/Y2005/M${mm}/MYD04_L2_${type}.aero_005.2005${mm}.hdf  $inpDir/Y2004/M${mm}/MYD04_L2_${type}.aero_005.2004${mm}.hdf  $inpDir/Y2003/M${mm}/MYD04_L2_${type}.aero_005.2003${mm}.hdf 
  end

 end

