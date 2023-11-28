sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin/geosgcm_surf/c90Fc_I10pa3_pin.geosgcm_surf.19910617_1030z.nc4
c
set grads off
set gxout shaded
set clevs 180 210 240 270 300 330 360 390 420
set lon 70 120
set lat -70 70
d scto3
cbarn
draw title Baseline O3 [DU] 19910617_1030z
gxprint c90Fc_I10pa3_pin.ozone_lats.png white


reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_noash/geosgcm_surf/c90Fc_I10pa3_pin_noash.geosgcm_surf.19910617_1030z.nc4
c
set grads off
set gxout shaded
set clevs 180 210 240 270 300 330 360 390 420
set lon 70 120
set lat -70 70
d scto3
cbarn
draw title No Ash O3 [DU] 19910617_1030z
gxprint c90Fc_I10pa3_pin_noash.ozone_lats.png white




reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash10/geosgcm_surf/c90Fc_I10pa3_pin_ash10.geosgcm_surf.19910617_1030z.nc4
c
set grads off
set gxout shaded
set clevs 180 210 240 270 300 330 360 390 420
set lon 70 120
set lat -70 70
d scto3
cbarn
draw title 1/10 Ash Injection O3 [DU] 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash10.ozone_lats.png white




reinit
sdfopen /misc/prc18/colarco/c90Fc_I10pa3_pin_ash02/geosgcm_surf/c90Fc_I10pa3_pin_ash02.geosgcm_surf.19910617_1030z.nc4
c
set grads off
set gxout shaded
set clevs 180 210 240 270 300 330 360 390 420
set lon 70 120
set lat -70 70
d scto3
cbarn
draw title 1/2 Ash Injection O3 [DU] 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash02.ozone_lats.png white
