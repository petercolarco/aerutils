xdfopen c180F_J10p17p1new_chl.tavg3d_aer_p.ctl
xdfopen c180F_J10p17p1new_chl0.tavg3d_aer_p.ctl
xdfopen c180F_J10p17p1new_uphl0.tavg3d_aer_p.ctl

set x 1
set t 6
set lev 1000 10
set zlog on
set grads off
set gxout shaded
c

nh31 = ave(nh3.1,lon=-180,lon=180)
nh32 = ave(nh3.2,lon=-180,lon=180)
nh33 = ave(nh3.3,lon=-180,lon=180)

set clevs .01 .1 .5
d nh31*1e9
cbarn
printim nh3.chl.png white

c
set clevs .01 .1 .5
d nh32*1e9
cbarn
printim nh3.chl0.png white

c
set clevs .01 .1 .5
d nh33*1e9
cbarn
printim nh3.uphl0.png white

c
d nh33*1e9-nh31*1e9
cbarn
printim nh3.uphl0-chl.png white

c
d nh32*1e9-nh31*1e9
cbarn
printim nh3.chl0-chl.png white
