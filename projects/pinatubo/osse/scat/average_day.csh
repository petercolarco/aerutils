#!/bin/csh

set EXPID = 'c90Fc_H54p3_pin'
set dir = './'

foreach MM (7)
foreach DD (02)
set M2 = $MM
if( $MM < 10) set M2 = '0'$MM
ls -1 $dir/ai.${EXPID}_aer_L2-OMAERUV_2007m$M2$DD* >> /dev/null

if($status == 0) then
set FILE = $dir/ai.${EXPID}_aer_L2-OMAERUV_2007m$M2${DD}t12*
#set FILE = $dir/ai.dR_MERRA-AA-r2-v153_Full_aer_L2-OMAERUV_2007m0605t1407Full.npz
sed 's#EXPID#'$EXPID'#g;s#MM#'$MM'#g;s#DD#'$DD'#g;s#FILE#'$FILE'#g' grid_OMI_GEOS-5.monthly.tmp > grid_OMI_GEOS-5.monthly.tmp.py

chmod 744 grid_OMI_GEOS-5.monthly.tmp.py
./grid_OMI_GEOS-5.monthly.tmp.py

n4zip ai.nc4
n4zip aot.nc4
n4zip rad354.nc4
n4zip rad388.nc4
n4zip rad471.nc4

\mv -f ai.nc4 $dir/$EXPID.ai.2007$M2$DD.nc4
\mv -f aot.nc4 $dir/$EXPID.aot.2007$M2$DD.nc4
\mv -f rad354.nc4 $dir/$EXPID.rad354.2007$M2$DD.nc4
\mv -f rad388.nc4 $dir/$EXPID.rad388.2007$M2$DD.nc4
\mv -f rad471.nc4 $dir/$EXPID.rad471.2007$M2$DD.nc4

rm -f ./grid_OMI_GEOS-5.monthly.tmp.py

endif

end
end
