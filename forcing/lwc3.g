sdfopen /misc/prc14/colarco/bF_F25b9-base-v6/geosgcm_surf/bF_F25b9-base-v6.geosgcm_surf.monthly.clim.JJA.nc4 
sdfopen /misc/prc14/colarco/bF_F25b9-base-v1/geosgcm_surf/bF_F25b9-base-v1.geosgcm_surf.monthly.clim.JJA.nc4 

set gxout shaded
set lon -100 40
set lat -15 45

define toa1 = olrc-olrcna
define toa2 = olrc.2-olrcna.2
define sfc1 = lwsc-lwscna
define sfc2 = lwsc.2-lwscna.2

xycomp toa1 toa2
plotpng olrc.v6_v1.png

xycomp sfc1 sfc2
plotpng lwsc.v6_v1.png


define atm1 = toa1-sfc1
define atm2 = toa2-sfc2
xycomp atm1 atm2
plotpng lwatmc.v6_v1.png
