set expid = c90R

sdfopen /misc/prc18/colarco/${expid}_J10p17p6_grims/${expid}_J10p17p6_grims.tavg3d_carma_p.20110524_0900z.nc4

set lon -77
set lat 60 90
set lev 1000 100
set zlog on
set grads off
set gxout shaded

set clevs 10 20 30 40 50 60 70 80 90 100
d suextcoef*1e6

cbarn

set gxout contour
d h

printim suextcoef.${expid}.png white
