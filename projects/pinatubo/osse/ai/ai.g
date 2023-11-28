sdfopen /misc/prc20/colarco/pinatubo_osse/c90Fc_pin/OMI-Aura_L2-OMAERUV_2007m0617.vl_rad.grid.nc4 
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 1 2 3 4 5 6 7 8 9 10
d ai
cbarn
draw title Baseline AI 19910617_1030z
gxprint c90Fc_I10pa3_pin.ai.png white


reinit
sdfopen /misc/prc20/colarco/pinatubo_osse/c90Fc_pin_noash/OMI-Aura_L2-OMAERUV_2007m0617.vl_rad.grid.nc4 
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 1 2 3 4 5 6 7 8 9 10
d ai
cbarn
draw title No Ash AI 19910617_1030z
gxprint c90Fc_I10pa3_pin_noash.ai.png white




reinit
sdfopen /misc/prc20/colarco/pinatubo_osse/c90Fc_pin_ash10/OMI-Aura_L2-OMAERUV_2007m0617.vl_rad.grid.nc4 
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 1 2 3 4 5 6 7 8 9 10
d ai
cbarn
draw title 1/10 Ash Injection AI 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash10.ai.png white




reinit
sdfopen /misc/prc20/colarco/pinatubo_osse/c90Fc_pin_ash02/OMI-Aura_L2-OMAERUV_2007m0617.vl_rad.grid.nc4
c
set grads off
set gxout shaded
set lon 70 120
set lat -10 40
set clevs 1 2 3 4 5 6 7 8 9 10
d ai
cbarn
draw title 1/2 Ash Injection AI 19910617_1030z
gxprint c90Fc_I10pa3_pin_ash02.ai.png white
