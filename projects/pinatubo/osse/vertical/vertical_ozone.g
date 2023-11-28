sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin/c90Fc_I10pa3_pin.inst3d_carma_v.19910617_1200z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set z 1 72
d ave((o3)*1e6,lat=10,lat=15)
cbarn
draw title Baseline O3 [ppmv] 19910617_1200z
gxprint c90Fc_I10pa3_pin.o3mmr.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_noash/c90Fc_I10pa3_pin_noash.inst3d_carma_v.19910617_1200z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set z 1 72
d ave((o3)*1e6,lat=10,lat=15)
cbarn
draw title No Ash O3 [ppmv] 19910617_1200z
gxprint c90Fc_I10pa3_pin_noash.o3mmr.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash10/c90Fc_I10pa3_pin_ash10.inst3d_carma_v.19910617_1200z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set z 1 72
d ave((o3)*1e6,lat=10,lat=15)
cbarn
draw title 1/10 Ash Injection O3 [ppmv] 19910617_1200z
gxprint c90Fc_I10pa3_pin_ash10.o3mmr.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash02/c90Fc_I10pa3_pin_ash02.inst3d_carma_v.19910617_1200z.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat 12
set z 1 72
d ave((o3)*1e6,lat=10,lat=15)
cbarn
draw title 1/2 Ash Injection O3 [ppmv] 19910617_1200z
gxprint c90Fc_I10pa3_pin_ash02.o3mmr.png white
