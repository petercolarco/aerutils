#!/bin/csh

set EXPID = 'dR_F25b18'
set dir = '/misc/prc14/colarco/'$EXPID'/inst3d_aer_v/lift_0km/'

set MM = '9'
set DD = '04'

set FILE = $dir/ai.${EXPID}_aer_L2-OMAERUV_2007m0904t1840
sed 's#EXPID#'$EXPID'#g;s#MM#'$MM'#g;s#DD#'$DD'#g;s#FILE#'$FILE'#g' grid_OMI_GEOS-5.monthly.tmp > grid_OMI_GEOS-5.monthly.tmp.py

chmod 744 grid_OMI_GEOS-5.monthly.tmp.py
./grid_OMI_GEOS-5.monthly.tmp.py

n4zip ai.nc4
n4zip aot.nc4
n4zip rad354.nc4
n4zip rad388.nc4
n4zip rad471.nc4

\mv -f ai.nc4 $dir/$EXPID.ai.20070904.nc4
\mv -f aot.nc4 $dir/$EXPID.aot.20070904.nc4
\mv -f rad354.nc4 $dir/$EXPID.rad354.20070904.nc4
\mv -f rad388.nc4 $dir/$EXPID.rad388.20070904.nc4
\mv -f rad471.nc4 $dir/$EXPID.rad471.20070904.nc4

rm -f ./grid_OMI_GEOS-5.monthly.tmp.py

