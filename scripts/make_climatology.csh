#!/bin/csh
# Use this script to make a climatology of some years of data from a
# typical run
# Assumes monthly averages already completed for all years
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set gfiomean = /home/colarco/bin/GFIO_mean_r8.x
set exppath  = /misc/prc11/colarco/
set expid    = bR_QFEDa1


mkdir -p $exppath/$expid/diag/clim

foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)
  mkdir -p $exppath/$expid/diag/clim/M$mm


  $gfiomean -o $exppath/$expid/diag/clim/M$mm/${expid}.chem_diag.sfc.clim${mm}.hdf \
               $exppath/$expid/diag/Y????/M$mm/${expid}.chem_diag.sfc.????${mm}.hdf
  $gfiomean -o $exppath/$expid/diag/clim/M$mm/${expid}.chem_diag.eta.clim${mm}.hdf \
               $exppath/$expid/diag/Y????/M$mm/${expid}.chem_diag.eta.????${mm}.hdf

 end

end

