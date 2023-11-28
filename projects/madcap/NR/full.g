reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.full.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim full.png white

reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.full.day.cloud.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim full.cloud.png white
