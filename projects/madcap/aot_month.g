sdfopen c180R_pI33p7.iss.totexttau.monthly.20160415_1200z.nc4
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim iss.png white

reinit
sdfopen c180R_pI33p7.calipso.totexttau.monthly.20160415_1200z.nc4
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso.png white

reinit
xdfopen c180R_pI33p7.monthly.ddf
set t 4
set lon -180 180
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim geos.png white
