#!/bin/tcsh
foreach species (co bc oc co2 so2 nh3)
 lats4d.sh -v -i emis_${species}.ctl \
              -o tmp -ftype xdf -vars emis -geos0.5a
 ncatted -O -a units,time,o,c,"days since 1980-1-15 12" tmp.nc
 ncrename -v emis,biomass tmp.nc \
          /misc/prc14/colarco/MAP16_BB/clm4_5.emis_${species}.x576_y361_t444.19800115_12z_20161215_12z.nc

end
