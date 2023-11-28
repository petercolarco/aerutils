#!/bin/csh
# Use this script to form a monthly average of the diag.sfc file (or other)
# Assumes daily averages already completed
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set gfiomean = /home/colarco/sourcemotel/FVGCM-hold/src/shared/gfio/r8/GFIO_mean_r8.x
set exppath  = /output6/MISR/Level3/GRITAS
set lats4d   = /home/colarco/bin/lats4d

foreach year ( 2000 2001 2002 2003 2004 2005 2006)
#foreach year ( 2003 2004 2005)
foreach month (01 02 03 04 05 06 07 08 09 10 11 12)
foreach expid (misr)

  /bin/rm -f $exppath/Y${year}/M{$month}/${expid}.aero.${year}${month}.hdf

  $gfiomean -o $exppath/Y${year}/M{$month}/${expid}.aero.${year}${month}.hdf \
               $exppath/Y${year}/M{$month}/${expid}.aero.${year}${month}??.hdf

  $lats4d -i $exppath/Y${year}/M{$month}/${expid}.aero.${year}${month}.hdf \
          -o test.nc -lon 0 358.75
  mv -f test.nc $exppath/Y${year}/M{$month}/${expid}.aero.${year}${month}.hdf
  

end

end
end

