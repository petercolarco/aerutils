#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/colarco/MODIS/Level3/new/GRITAS

  foreach type (lnd ocn)

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
      $gfiomean -vars aodtau -o MYD04_L2_${type}.clim_004.2003_2005_${mm}_pete.hdf $inpDir/Y200?/M${mm}/MYD04_L2_${type}.aero_004.200?${mm}.hdf
  end

 end

