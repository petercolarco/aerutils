reinit
sdfopen /misc/prc19/colarco/OMAERUV_V1891_DATA/2016/09/03/OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4

set lon -30 45
set lat -40 20
set mpdset hires
set grads off
set gxout grfill

c
set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d ssa
cbarn
draw title OMI SSA 
printim ssa_OMI.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura/OMAERUV/c180R_v202_aura.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(mssa.2,ssa)
cbarn
draw title c180R_v202_aura SSA 
printim ssa_aura.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_nosoa/OMAERUV/c180R_v202_aura_nosoa.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(mssa.3,ssa)
cbarn
draw title c180R_v202_aura_nosoa SSA 
printim ssa_aura_nosoa.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_gsfun/OMAERUV/c180R_v202_aura_gsfun.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(mssa.4,ssa)
cbarn
draw title c180R_v202_aura_gsfun SSA 
printim ssa_aura_gsfun.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_schill/OMAERUV/c180R_v202_aura_schill.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(mssa.5,ssa)
cbarn
draw title c180R_v202_aura_schill SSA 
printim ssa_aura_schill.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_ceds/OMAERUV/c180R_v202_ceds.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(mssa.6,ssa)
cbarn
draw title c180R_v202_ceds SSA 
printim ssa_ceds.20160903.png white

c
d maskout(mssa.2-mssa.3,ssa)
cbarn
draw title SSA: aura - aura_nosoa
printim ssa_diff_v_nosoa.20160903.png white

c
d maskout(mssa.2-mssa.4,ssa)
cbarn
draw title SSA: aura - aura_gsfun
printim ssa_diff_v_gsfun.20160903.png white

c
d maskout(mssa.4-mssa.5,ssa)
cbarn
draw title SSA: aura_gsfun - aura_schill
printim ssa_diff_gsfun_v_schill.20160903.png white

c
d maskout(mssa.4-mssa.6,ssa)
cbarn
draw title SSA: aura_gsfun - ceds
printim ssa_diff_gsfun_v_ceds.20160903.png white
