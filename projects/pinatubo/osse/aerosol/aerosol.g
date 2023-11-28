sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin/tavg2d_carma_x/c90Fc_I10pa3_pin.tavg2d_carma_x.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs .5 1 1.5 2 2.5 3 3.5 4
d suexttau+duexttau
cbarn
draw title Baseline AOD 19910617_1030z
gxprint c90Fc_I10pa3_pin.aod.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_noash/tavg2d_carma_x/c90Fc_I10pa3_pin_noash.tavg2d_carma_x.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs .5 1 1.5 2 2.5 3 3.5 4
d suexttau+duexttau
cbarn
draw title No Ash AOD 19910617_1030z
gxprint c90Fc_I10pa3_pin_noash.aod.png white




reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash10/tavg2d_carma_x/c90Fc_I10pa3_pin_ash10.tavg2d_carma_x.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs .5 1 1.5 2 2.5 3 3.5 4
d suexttau+duexttau
cbarn
draw title 1/10 Ash Injection AOD 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash10.aod.png white




reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash02/tavg2d_carma_x/c90Fc_I10pa3_pin_ash02.tavg2d_carma_x.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs .5 1 1.5 2 2.5 3 3.5 4
d suexttau+duexttau
cbarn
draw title 1/2 Ash Injection AOD 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash02.aod.png white
