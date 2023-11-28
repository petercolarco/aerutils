#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/MODIS/Level3/MOD04/GRITAS

  foreach type (lnd ocn)

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
      $gfiomean -vars AODTAU -o MOD04_L2_ocn.clim_005.2000_2001_2002_2005_${mm}_pete.hdf  $inpDir/Y2005/M${mm}/MOD04_L2_ocn.aero_005.2005${mm}.hdf $inpDir/Y2002/M${mm}/MOD04_L2_ocn.aero_005.2002${mm}.hdf   $inpDir/Y2001/M${mm}/MOD04_L2_ocn.aero_005.2001${mm}.hdf $inpDir/Y2000/M${mm}/MOD04_L2_ocn.aero_005.2000${mm}.hdf 
  end

 end

