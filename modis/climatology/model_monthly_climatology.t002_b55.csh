#!/bin/csh

  set gfiomean = /home/colarco/sourcemotel/petechem-1_0r11/FVGCM/src/shared/gfio/r8/GFIO_mean_r8.x
  set inpDir = /output/colarco/t002_b55/tau/

  foreach mm  (01 02 03 04 05 06 07 08 09 10 11 12)
   $gfiomean -o model_match_clim_2000${mm}.t002_b55.hdf $inpDir/Y200?/M${mm}/t002_b55.tau2d.200?${mm}.hdf
  end


