#!/bin/tcsh

foreach file (`ls -1 d5_arctas_02.*.nc`)
 set date = `echo $file:r:e`
 set loc  = `echo $file:r:r:e`
 mv $file GEOS5_${loc}_curtain.$date.nc
end

