reinit
sdfopen /misc/prc19/colarco/OMAERUV_V1891_DATA/2016/09/03/OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4

set lon -30 45
set lat -40 20
set mpdset hires
set grads off
set gxout grfill

c
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d ai
cbarn
draw title OMI AI 
printim ai_OMI.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura/OMAERUV/c180R_v202_aura.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai.2,ai+0.5)
cbarn
draw title c180R_v202_aura AI 
printim ai_aura.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_nosoa/OMAERUV/c180R_v202_aura_nosoa.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai.3,ai+0.5)
cbarn
draw title c180R_v202_aura_nosoa AI 
printim ai_aura_nosoa.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_gsfun/OMAERUV/c180R_v202_aura_gsfun.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai.4,ai+0.5)
cbarn
draw title c180R_v202_aura_gsfun AI 
printim ai_aura_gsfun.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_schill/OMAERUV/c180R_v202_aura_schill.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai.5,ai+0.5)
cbarn
draw title c180R_v202_aura_schill AI 
printim ai_aura_schill.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_ceds/OMAERUV/c180R_v202_ceds.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai.6,ai+0.5)
cbarn
draw title c180R_v202_ceds AI 
printim ai_ceds.20160903.png white

c
d maskout(ai.2-ai.3,ai+0.5)
cbarn
draw title AI: aura - aura_nosoa
printim ai_diff_v_nosoa.20160903.png white

c
d maskout(ai.2-ai.4,ai+0.5)
cbarn
draw title AI: aura - aura_gsfun
printim ai_diff_v_gsfun.20160903.png white

c
d maskout(ai.4-ai.5,ai+0.5)
cbarn
draw title AI: aura_gsfun - aura_schill
printim ai_diff_gsfun_v_schill.20160903.png white

c
d maskout(ai.4-ai.6,ai+0.5)
cbarn
draw title AI: aura_gsfun - aura_ceds
printim ai_diff_gsfun_v_ceds.20160903.png white

