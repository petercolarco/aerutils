sdfopen /misc/prc14/colarco/bF_F25b9-base-v8/geosgcm_surf/bF_F25b9-base-v8.geosgcm_surf.monthly.clim.JJA.nc4 
sdfopen /misc/prc14/colarco/bF_F25b9-base-v1/geosgcm_surf/bF_F25b9-base-v1.geosgcm_surf.monthly.clim.JJA.nc4 

set gxout shaded
set lon -100 40
set lat -15 45

define toa1 = maskout((swtnetc-swtnetcna) / ttaudu, ttaudu-0.01)
define toa2 = maskout((swtnetc.2-swtnetcna.2) / ttaudu.2, ttaudu.2-0.01)
define sfc1 = maskout((swgnetc-swgnetcna) / ttaudu, ttaudu-0.01)
define sfc2 = maskout((swgnetc.2-swgnetcna.2) / ttaudu.2, ttaudu.2-0.01)

xycomp toa1 toa2
plotpng swtnetc_.v8_v1.png

xycomp sfc1 sfc2
plotpng swgnetc_.v8_v1.png


define atm1 = toa1-sfc1
define atm2 = toa2-sfc2
xycomp atm1 atm2
plotpng swatmc_.v8_v1.png
