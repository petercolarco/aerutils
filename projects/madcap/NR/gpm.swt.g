reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.gpm.nodrag.100km.swt.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -80 -60 -40 -20 -10 -2 2 10 20 40
d swtnt-swtntcln
cbarn
printim gpm.nodrag.100km.swt.png white

reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.gpm.nodrag.300km.swt.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -80 -60 -40 -20 -10 -2 2 10 20 40
d swtnt-swtntcln
cbarn
printim gpm.nodrag.300km.swt.png white

reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.gpm.nodrag.500km.swt.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -80 -60 -40 -20 -10 -2 2 10 20 40
d swtnt-swtntcln
cbarn
printim gpm.nodrag.500km.swt.png white

reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.gpm.nodrag.1000km.swt.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -80 -60 -40 -20 -10 -2 2 10 20 40
d swtnt-swtntcln
cbarn
printim gpm.nodrag.1000km.swt.png white
