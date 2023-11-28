xdfopen bR_Fortuna-2_5-b7.tavg2d_aer_x.ctl
xdfopen b_F25b7-base-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v5.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v6.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v7.tavg2d_carma_x.ctl

set t 6
set lon -80 0
set lat 0 40
set gxout shaded

set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau
cbarn
plotpng replay.png

c
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau.2
cbarn
plotpng free.png

c
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau.3
cbarn
plotpng v1.png

c
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau.4
cbarn
plotpng v5.png

c
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau.5
cbarn
plotpng v6.png

c
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau.6
cbarn
plotpng v7.png
