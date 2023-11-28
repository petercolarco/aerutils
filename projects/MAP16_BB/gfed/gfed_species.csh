#!/bin/tcsh
foreach species (co bc oc co2 so2 nh3)

 lats4d.sh -v -i gfedv4.1s_gridded_monthly.ctl \
              -o tmp -ftype xdf -vars ${species}_bb -geos0.25a
 ncatted -O -a units,time,o,c,"days since 1997-1-15 12" tmp.nc
 ncrename -v ${species}_bb,biomass tmp.nc \
          /misc/prc14/colarco/GFED/gfedv4_1s.emis_${species}.x1152_y721_t240.19970115_12z_20191215_12z.nc
end
