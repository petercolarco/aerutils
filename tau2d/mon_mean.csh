#!/bin/csh
# Use this script to form a monthly average of the diag.sfc file (or other)
# Assumes daily averages already completed
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

# Do it
foreach expid ( t003_c32 )

set exppath  = /output/colarco/$expid/diag/

foreach year (2000 2001 2002 2003 2004 2005 2006)
foreach month (01 02 03 04 05 06 07 08 09 10 11 12)

#GFIO_mean_r8.x -o $exppath/Y$year/M$month/$expid.tau2d.v2.$year$month.hdf $exppath/Y$year/M$month/$expid.tau2d.v2.$year${month}??.hdf

end
GFIO_mean_r8.x -o $exppath/Y$year/$expid.chem_diag.sfc.$year.hdf $exppath/Y$year/M??/$expid.chem_diag.sfc.${year}??.hdf

end

end
