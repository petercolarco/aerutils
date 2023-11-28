xdfopen ../ctl/bR_Fortuna-2_5-b2.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 10 20 40 80 160 320 640 1280
set gxout shaded
define ssc = aave(ss,g)*1e12
d ssc
cbarn
draw title bR_Fortuna-2_5-b2 SS mixing ratio ng kg-1
plotpng ssvmass.bR_Fortuna-2_5-b2.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b4.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 10 20 40 80 160 320 640 1280
set gxout shaded
define ssc = aave(ss,g)*1e12
d ssc
cbarn
draw title bR_Fortuna-2_5-b4 SS mixing ratio ng kg-1
plotpng ssvmass.bR_Fortuna-2_5-b4.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b5.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 10 20 40 80 160 320 640 1280
set gxout shaded
define ssc = aave(ss,g)*1e12
d ssc
cbarn
draw title bR_Fortuna-2_5-b5 SS mixing ratio ng kg-1
plotpng ssvmass.bR_Fortuna-2_5-b5.png

