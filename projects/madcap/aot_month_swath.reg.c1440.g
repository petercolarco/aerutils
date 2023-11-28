reinit
sdfopen c1440_NR.full.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim full.reg.c1440.png white

reinit
sdfopen c1440_NR.full_day.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim full_day.reg.c1440.png white

reinit
sdfopen c1440_NR.full_day_cloud.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim full_day_cloud.reg.c1440.png white

reinit
sdfopen c1440_NR.calipso.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso.reg.c1440.png white

reinit
sdfopen c1440_NR.calipso_day.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso_day.reg.c1440.png white

reinit
sdfopen c1440_NR.calipso_day_cloud.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso_day_cloud.reg.c1440.png white

reinit
sdfopen c1440_NR.calipso_swath.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso_swath.reg.c1440.png white

reinit
sdfopen c1440_NR.calipso_swath_day.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso_swath_day.reg.c1440.png white

reinit
sdfopen c1440_NR.calipso_swath_day_cloud.monthly.200606.nc
set lon -60 0
set lat   0 40
set gxout grfill
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
printim calipso_swath_day_cloud.reg.c1440.png white

