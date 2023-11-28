sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin/tavg3d_carma_p/c90Fc_I10pa3_pin.tavg3d_carma_p.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set lev 100 5
set zlog on
set clevs 50 100 150 200 250 300 350 400 450 500 550 600
d ave((suextcoef+duextcoef)*1e6,lat=10,lat=15)
cbarn
set gxout contour
set clevs 1 2 3 4 5 6 7 8
d ave(o3*1e6,lat=10,lat=15)
draw title Baseline Extinction [Mm-1]/O3 [ppm] 19910617_1030z
gxprint c90Fc_I10pa3_pin.ext.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_noash/tavg3d_carma_p/c90Fc_I10pa3_pin_noash.tavg3d_carma_p.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set lev 100 5
set zlog on
set clevs 50 100 150 200 250 300 350 400 450 500 550 600
d ave((suextcoef+duextcoef)*1e6,lat=10,lat=15)
cbarn
set gxout contour
set clevs 1 2 3 4 5 6 7 8
d ave(o3*1e6,lat=10,lat=15)
draw title No Ash Extinction [Mm-1]/O3 [ppm] 19910617_1030z
gxprint c90Fc_I10pa3_pin_noash.ext.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash02/tavg3d_carma_p/c90Fc_I10pa3_pin_ash02.tavg3d_carma_p.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set lev 100 5
set zlog on
set clevs 50 100 150 200 250 300 350 400 450 500 550 600
d ave((suextcoef+duextcoef)*1e6,lat=10,lat=15)
cbarn
set gxout contour
set clevs 1 2 3 4 5 6 7 8
d ave(o3*1e6,lat=10,lat=15)
draw title 1/2 Ash Injection Extinction [Mm-1]/O3 [ppm] 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash02.ext.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash10/tavg3d_carma_p/c90Fc_I10pa3_pin_ash10.tavg3d_carma_p.19910617_1030z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set lev 100 5
set zlog on
set clevs 50 100 150 200 250 300 350 400 450 500 550 600
d ave((suextcoef+duextcoef)*1e6,lat=10,lat=15)
cbarn
set gxout contour
set clevs 1 2 3 4 5 6 7 8
d ave(o3*1e6,lat=10,lat=15)
draw title 1/10 Ash Injection Extinction [Mm-1]/O3 [ppm] 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash10.ext.png white
