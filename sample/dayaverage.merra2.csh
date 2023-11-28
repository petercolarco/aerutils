#!/bin/csh

# Process daily averages
foreach yyyy (2003 2004 2005 2006 2007 2008 2009 2010 2011 2012)
foreach mm   (01 02 03 04 05 06 07 08 09 10 11 12)


foreach dd (01 02 03 04 05 06 07 08 09 10 \
            11 12 13 14 15 16 17 18 19 20 \
            21 22 23 24 25 26 27 28 29 30 31)

lats4d.sh -v -i dR_MERRA-AA-r2.ddf -o tmp -time 0z${dd}jul2007 23z${dd}jul2007 -func "dayswath(totexttau,aqua,2330)" -vars totexttau
rm -f inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.modis_aqua.200707${dd}.nc4
GFIO_mean_r8.x -o inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.modis_aqua.200707${dd}.nc4 tmp.nc

lats4d.sh -v -i dR_MERRA-AA-r2.ddf -o tmp -time 0z${dd}jul2007 23z${dd}jul2007 -func "dayswath(totexttau,aqua,380)" -vars totexttau
rm -f inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.misr_aqua.200707${dd}.nc4
GFIO_mean_r8.x -o inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.misr_aqua.200707${dd}.nc4 tmp.nc

lats4d.sh -v -i dR_MERRA-AA-r2.ddf -o tmp -time 0z${dd}jul2007 23z${dd}jul2007 -func "orb_mask(totexttau,aqua)*if(cosz(totexttau,h),>,0,1,-u)" -vars totexttau
rm -f inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.200707${dd}.nc4
GFIO_mean_r8.x -o inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.200707${dd}.nc4 tmp.nc

end

rm -f inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.modis_aqua.200707.nc4
GFIO_mean_r8.x -o inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.modis_aqua.200707.nc4 \
                  inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.modis_aqua.200707??.nc4
rm -f inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.misr_aqua.200707.nc4
GFIO_mean_r8.x -o inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.misr_aqua.200707.nc4 \
                  inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.misr_aqua.200707??.nc4
rm -f inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.200707.nc4
GFIO_mean_r8.x -o inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.200707.nc4 \
                  inst2d_hwl_x/Y$yyyy/M$mm/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.200707??.nc4
end
end
