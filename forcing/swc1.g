sdfopen /misc/prc14/colarco/bF_F25b9-base-v8/geosgcm_surf/bF_F25b9-base-v8.geosgcm_surf.monthly.clim.JJA.nc4 
sdfopen /misc/prc14/colarco/bF_F25b9-base-v1/geosgcm_surf/bF_F25b9-base-v1.geosgcm_surf.monthly.clim.JJA.nc4 

set gxout shaded
set lon -100 40
set lat -15 45

define toa1 = swtnetc-swtnetcna
define toa2 = swtnetc.2-swtnetcna.2
define sfc1 = swgnetc-swgnetcna
define sfc2 = swgnetc.2-swgnetcna.2

xycomp toa1 toa2
plotpng swtnetc.v8_v1.png

xycomp sfc1 sfc2
plotpng swgnetc.v8_v1.png


define atm1 = toa1-sfc1
define atm2 = toa2-sfc2
xycomp atm1 atm2
plotpng swatmc.v8_v1.png
