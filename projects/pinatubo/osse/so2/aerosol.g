sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin/tavg2d_aer_x/199106/c90Fc_I10pa3_pin.tavg2d_aer_x.19910617_0900z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 30 40 50 60 70 80 90 100 110 120 130 140 150
d so2cmassvolc/0.064*6.02e23/2.69e20
cbarn
draw title Baseline SO2CMASSVOLC [DU] 19910617_0900z
gxprint c90Fc_I10pa3_pin.so2cmassvolc.png white
d aave(so2cmassvolc,g)*5.1e8

reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_noash/tavg2d_aer_x/199106/c90Fc_I10pa3_pin_noash.tavg2d_aer_x.19910617_0900z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 30 40 50 60 70 80 90 100 110 120 130 140 150
d so2cmassvolc/0.064*6.02e23/2.69e20
cbarn
draw title No Ash SO2CMASSVOLC [DU] 19910617_0900z
gxprint c90Fc_I10pa3_pin_noash.so2cmassvolc.png white
d aave(so2cmassvolc,g)*5.1e8




reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash10/tavg2d_aer_x/199106/c90Fc_I10pa3_pin_ash10.tavg2d_aer_x.19910617_0900z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 30 40 50 60 70 80 90 100 110 120 130 140 150
d so2cmassvolc/0.064*6.02e23/2.69e20
cbarn
draw title 1/10 Ash Injection SO2CMASSVOLC [DU] 19910617_0900z
gxprint c90Fc_I10pa3_pin_ash10.so2cmassvolc.png white
d aave(so2cmassvolc,g)*5.1e8




reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash02/tavg2d_aer_x/199106/c90Fc_I10pa3_pin_ash02.tavg2d_aer_x.19910617_0900z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 30 40 50 60 70 80 90 100 110 120 130 140 150
d so2cmassvolc/0.064*6.02e23/2.69e20
cbarn
draw title 1/2 Ash Injection SO2CMASSVOLC [DU] 19910617_0900z
gxprint c90Fc_I10pa3_pin_ash02.so2cmassvolc.png white
d aave(so2cmassvolc,g)*5.1e8
