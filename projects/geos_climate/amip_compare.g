xdfopen S2S_clim1850.ddf
xdfopen AMIP1850.ddf

set lon -180 180
set gxout shaded
set grads off

set t 1
aod1 = ave(totexttau,t=1,t=12)
aod2 = ave(totexttau.2,t=1,t=12)
xycomp aod1 aod2
printim totexttau.png white

c
aod1 = ave(duexttau,t=1,t=12)
aod2 = ave(duexttau.2,t=1,t=12)
xycomp aod1 aod2
printim duexttau.png white

c
su1 = ave(supso4wt+supso4aq,t=1,t=12)
su2 = ave(supso4wt.2+supso4aq.2,t=1,t=12)
xycomp su1*30*86400*1e6 su2*30*86400*1e6
printim pso4wet.png white
