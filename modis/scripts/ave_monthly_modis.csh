#!/bin/csh
# Use this script to form a monthly average of the diag.sfc file (or other)
# Assumes daily averages already completed
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set gfiomean = GFIO_mean_r8.x
set lats4d   = lats4d

set satellite = 'MOD04'
set resolution = 'b'
if($resolution == 'b') set lonmax = 357.5
if($resolution == 'c') set lonmax = 358.75
set exppath  = /output/colarco/MODIS/Level3/${satellite}/${resolution}/GRITAS

foreach year (2000 2001 2002 2003 2004 2005 2006 2007)
foreach month (01 02 03 04 05 06 07 08 09 10 11 12)
foreach expid ( ${satellite}_L2_lnd ${satellite}_L2_ocn)

  $gfiomean -o $exppath/Y${year}/M{$month}/${expid}.aero_005.qawt.${year}${month}.hdf \
               $exppath/Y${year}/M{$month}/${expid}.aero_005.qawt.${year}${month}??.hdf

  $gfiomean -o $exppath/Y${year}/M{$month}/${expid}.aero_005.qafl.${year}${month}.hdf \
               $exppath/Y${year}/M{$month}/${expid}.aero_005.qafl.${year}${month}??.hdf


  $lats4d -i $exppath/Y${year}/M{$month}/${expid}.aero_005.qawt.${year}${month}.hdf \
          -o test.nc -lon 0 $lonmax
  mv -f test.nc $exppath/Y${year}/M{$month}/${expid}.aero_005.qawt.${year}${month}.hdf
  
  $lats4d -i $exppath/Y${year}/M{$month}/${expid}.aero_005.qafl.${year}${month}.hdf \
          -o test.nc -lon 0 $lonmax
  mv -f test.nc $exppath/Y${year}/M{$month}/${expid}.aero_005.qafl.${year}${month}.hdf
  

end

end
end

