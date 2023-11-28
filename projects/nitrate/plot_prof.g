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

ni1 = ave(ni.1,lon=-180,lon=180)
ni2 = ave(ni.2,lon=-180,lon=180)
ni3 = ave(ni.3,lon=-180,lon=180)

set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5 .55 .6
d ni1*1e9
cbarn
printim ni.chl.png white

c
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5 .55 .6
d ni2*1e9
cbarn
printim ni.chl0.png white

c
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5 .55 .6
d ni3*1e9
cbarn
printim ni.uphl0.png white

c
d ni3*1e9-ni1*1e9
cbarn
printim ni.uphl0-chl.png white

c
d ni2*1e9-ni1*1e9
cbarn
printim ni.chl0-chl.png white
