set expid = c90R

sdfopen /misc/prc18/colarco/${expid}_J10p17p6_grims/${expid}_J10p17p6_grims.tavg3d_carma_p.20110524_0900z.nc4

set lon -77
set lat 60 90
set lev 1000 100
set zlog on
set grads off
set gxout shaded

set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
d sureff*1e6

cbarn

set gxout contour
d h

printim reff.${expid}.png white
