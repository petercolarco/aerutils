reinit
sdfopen c1440_NR.iss.nodrag.100km.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim iss.nodrag.100km.png white

reinit
sdfopen c1440_NR.iss.nodrag.100km.day.cloud.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim iss.nodrag.100km.cloud.png white

reinit
sdfopen c1440_NR.iss.nodrag.300km.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim iss.nodrag.300km.png white

reinit
sdfopen c1440_NR.iss.nodrag.300km.day.cloud.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim iss.nodrag.300km.cloud.png white
