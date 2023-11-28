#!/bin/csh
# Use this script to form a monthly average of the diag.sfc file (or other)
# Assumes daily averages already completed
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set gfiomean = /Users/colarco/AOD/Darwin/bin/GFIO_mean_r8.x
#set lats4d   = /home/colarco/bin/lats4d

foreach expid ("t003_c32" "t05_b32" "t006_b32")

#set expid = 't002_b55'
set exppath  = /output/colarco/${expid}/tau

foreach year (2000 2001 2002 2003 2004 2005 2006)
foreach month (01 02 03 04 05 06 07 08 09 10 11 12)

  $gfiomean -o $exppath/Y${year}/M{$month}/${expid}.tau2d.${year}${month}.hdf \
               $exppath/Y${year}/M{$month}/${expid}.tau2d.${year}${month}??.hdf
exit
#  $lats4d -i $exppath/Y${year}/M{$month}/${expid}.aero_${col}.qawt_pw.${year}${month}.hdf \
#          -o test.nc -lon 0 358.75
#  mv -f test.nc $exppath/Y${year}/M{$month}/${expid}.aero_${col}.qawt_pw.${year}${month}.hdf
  

end
end

end
