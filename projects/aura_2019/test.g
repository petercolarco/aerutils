reinit
sdfopen /misc/prc19/colarco/OMAERUV_V1891_DATA/2016/09/03/OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4

set lon -30 45
set lat -40 20
set mpdset hires
set grads off
set gxout grfill

sdfopen /misc/prc18/colarco/c180R_v202_aura/OMAERUV/c180R_v202_aura.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
sdfopen /misc/prc18/colarco/c180R_v202_aura_gsfun/OMAERUV/c180R_v202_aura_gsfun.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
sdfopen /misc/prc18/colarco/c180R_v202_aura_schill/OMAERUV/c180R_v202_aura_schill.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4

c
d maskout(ai.2-ai.3,ai)
cbarn
draw title AI: aura - aura_gsfun
printim test.ai_diff_v_gsfun.20160903.png white

c
d maskout(ai.3-ai.4,ai)
cbarn
draw title AI: aura_gsfun - aura_schill
printim test.ai_diff_gsfun_v_schill.20160903.png white
