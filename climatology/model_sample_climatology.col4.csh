#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/colarco/t003_c32/tau

  foreach type (lnd ocn)

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
      $gfiomean -o model_sample_clim_2000${mm}.${type}.hdf $inpDir/Y2000/M${mm}/t003_c32.tau2d.MOD04_004.${type}.200?${mm}.hdf  $inpDir/Y2001/M${mm}/t003_c32.tau2d.MOD04_004.${type}.200?${mm}.hdf  $inpDir/Y2002/M${mm}/t003_c32.tau2d.MOD04_004.${type}.200?${mm}.hdf  $inpDir/Y2003/M${mm}/t003_c32.tau2d.MOD04_004.${type}.200?${mm}.hdf  $inpDir/Y2004/M${mm}/t003_c32.tau2d.MOD04_004.${type}.200?${mm}.hdf
  end

 end

