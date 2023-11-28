xdfopen ../ctl/bR_Fortuna-2_5-b2.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
draw title bR_Fortuna-2_5-b2 BC mixing ratio ng kg-1
plotpng bcvmass.bR_Fortuna-2_5-b2.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b4.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
draw title bR_Fortuna-2_5-b4 BC mixing ratio ng kg-1
plotpng bcvmass.bR_Fortuna-2_5-b4.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b5.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
draw title bR_Fortuna-2_5-b5 BC mixing ratio ng kg-1
plotpng bcvmass.bR_Fortuna-2_5-b5.png

reinit
xdfopen ../ctl/bR_Fortuna-2_5-b2.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 12
set clevs 1 2 4 8 16 32 64 128
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
draw title bR_Fortuna-2_5-b2 BC mixing ratio ng kg-1
plotpng bcvmass.bR_Fortuna-2_5-b2.png
exit
reinit
xdfopen ../ctl/b_F25b2-noconv.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 24
set clevs 20 40 60 80 100 120 140 160
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
plotpng bcvmass.b_F25b2-noconv.png

reinit
xdfopen ../ctl/b_F25b2-noheat.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 24
set clevs 20 40 60 80 100 120 140 160
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
plotpng bcvmass.b_F25b2-noheat.png

reinit
xdfopen ../ctl/b_F25b2-emlast.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 24
set clevs 20 40 60 80 100 120 140 160
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
plotpng bcvmass.b_F25b2-emlast.png

reinit
xdfopen ../ctl/b_F25b2-philic.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 24
set clevs 20 40 60 80 100 120 140 160
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
plotpng bcvmass.b_F25b2-philic.png

reinit
xdfopen ../ctl/b_F25b2-incscav.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 24
set clevs 20 40 60 80 100 120 140 160
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
plotpng bcvmass.b_F25b2-incscav.png
