reinit
sdfopen /misc/prc19/colarco/c1440_NR/NR/c1440_NR.swt.day.monthly.200601.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -80 -60 -40 -20 -10 -2 2 10 20 40
d swtnt-swtntcln
cbarn
printim full.swt.png white

