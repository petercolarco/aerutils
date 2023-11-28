#!/bin/csh
# Use this script to form a daily average of the diag.sfc file (or other)
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set homedir = /Users/colarco/sandbox/aerutils/scripts
cd $homedir
echo $homedir
set yyyy  = `cat $homedir/.date1 | awk '{print $1}'`
set mm    = `cat $homedir/.date1 | awk '{print $2}'`

echo $yyyy
echo $mm

if($mm < 10) then
set mm = 0$mm
endif

set gfiomean = /Users/colarco/bin/GFIO_mean_r8.x
set exppath  = /output/colarco/MISR/Level3/c/GRITAS/
set expid    = MISR


  $gfiomean -o $exppath/Y${yyyy}/M{$mm}/${expid}.aero.qawt.${yyyy}${mm}.hdf \
               $exppath/Y${yyyy}/M{$mm}/${expid}.aero.qawt.${yyyy}${mm}??.hdf
  $gfiomean -o $exppath/Y${yyyy}/M{$mm}/${expid}.aero.qafl.${yyyy}${mm}.hdf \
               $exppath/Y${yyyy}/M{$mm}/${expid}.aero.qafl.${yyyy}${mm}??.hdf


# increment the date
echo $yyyy $mm
@ mm = $mm + 1
if($mm > 12) then
@ yyyy = $yyyy + 1
@ mm = $mm - 12
endif

cat > $homedir/.date1 << EOF
$yyyy $mm
EOF

if($mm < 10) then
 set mm = 0$mm
endif

if($yyyy$mm < 200706) then
  $homedir/monthly.csh
endif

exit
