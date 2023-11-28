#!/bin/csh
# Use this script to regrid the climatology to b resolution
# Assumes monthly averages already completed for all years
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set lats4d = /share/dasilva/opengrads/Linux/lats4d
set exppath  = /output/colarco/
set expid    = t003_c32

foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

  $lats4d -i $exppath/$expid/diag/clim/M$mm/${expid}.chem_diag.sfc.clim${mm}.hdf \
          -o test -geos2x25a
  /bin/mv -f test.nc \
             $exppath/$expid/diag/clim/M$mm/${expid}.chem_diag.sfc.clim${mm}.regrid_2x25.hdf

end
