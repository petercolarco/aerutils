xdfopen c180F_J10p17p1new_chl.tavg3d_aer_p.ctl
xdfopen Icarusr6r6.tavg3d_aer_p.ctl

set x 1
set t 30
set lev 1000 10
set zlog on
set grads off
set gxout shaded
c

nh41 = ave(nh4.1,lon=-180,lon=180)
nh42 = ave(nh4.2,lon=-180,lon=180)

set clevs .01 .1 .5
d nh41*1e9
cbarn
printim nh4.chl_t30.png white

c
set clevs .01 .1 .5
d nh42*1e9
cbarn
printim nh4.ica_t30.png white

