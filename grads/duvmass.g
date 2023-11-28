xdfopen ../ctl/bR_Fortuna-2_5-b2.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128 256 512 1024 2048 4096
set gxout shaded
define duc = aave(du,g)*1e12
d duc
cbarn
draw title bR_Fortuna-2_5-b2 DU mixing ratio ng kg-1
plotpng duvmass.bR_Fortuna-2_5-b2.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b4.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128 256 512 1024 2048 4096
set gxout shaded
define duc = aave(du,g)*1e12
d duc
cbarn
draw title bR_Fortuna-2_5-b4 DU mixing ratio ng kg-1
plotpng duvmass.bR_Fortuna-2_5-b4.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b5.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128 256 512 1024 2048 4096
set gxout shaded
define duc = aave(du,g)*1e12
d duc
cbarn
draw title bR_Fortuna-2_5-b5 DU mixing ratio ng kg-1
plotpng duvmass.bR_Fortuna-2_5-b5.png

