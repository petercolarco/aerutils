xdfopen ../ctl/bF_F25b9-base-v1.geosgcm_surf.ctl
xdfopen ../ctl/bF_F25b9-base-v6.geosgcm_surf.ctl

set t 6
set gxout shaded
set lon -100 0
set lat -15 45

define toa1 = maskout(swtnetcna-swtnetc,frocean-0.9)
define toa2 = maskout(swtnetcna.2-swtnetc.2,frocean-0.9)
define sfc1 = maskout(swgnetcna-swgnetc,frocean-0.9)
define sfc2 = maskout(swgnetcna.2-swgnetc.2,frocean-0.9)

xycomp toa1 toa2
plotpng swtnetc.v1_v6.png

xycomp sfc1 sfc2
plotpng swgnetc.v1_v6.png


define atm1 = sfc1-toa1
define atm2 = sfc2-toa2
xycomp atm1 atm2
plotpng swatm.v1_v6.png
