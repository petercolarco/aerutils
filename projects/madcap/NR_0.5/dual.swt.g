reinit
xdfopen c1440_NR.dual.300km.swt.day.monthly.ddf
set t 4
set lon -180 180
set gxout grfill
set grads off
set clevs -80 -60 -40 -20 -10 -2 2 10 20 40
d swtnt-swtntcln
cbarn
printim dual.nodrag.300km.swt.png white
