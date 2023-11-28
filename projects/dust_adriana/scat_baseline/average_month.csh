#!/bin/csh
foreach vers (v14_2)

sed 's#VERSION#'$vers'#g' grid_OMI_GEOS-5.monthly.tmp > grid_OMI_GEOS-5.monthly.tmp.py

chmod 744 grid_OMI_GEOS-5.monthly.tmp.py
./grid_OMI_GEOS-5.monthly.tmp.py
rm -f ./grid_OMI_GEOS-5.monthly.tmp.py

set outdir = /misc/prc14/colarco/dR_F25b18/aerosol_index/$vers
\mv -f merra_ai.nc4     $outdir/ai.monthly.200707.nc4
\mv -f merra_aot.nc4    $outdir/aot.monthly.200707.nc4
\mv -f merra_rad354.nc4 $outdir/rad354.monthly.200707.nc4
\mv -f merra_rad388.nc4 $outdir/rad388.monthly.200707.nc4
\mv -f merra_rad471.nc4 $outdir/rad471.monthly.200707.nc4

end
