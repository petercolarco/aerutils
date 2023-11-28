reinit
sdfopen /misc/prc19/colarco/OMAERUV_V1891_DATA/2016/09/03/OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4

set lon -30 45
set lat -40 20
set mpdset hires
set grads off
set gxout grfill

c
set clevs 0 0.5 1 1.5 2 2.5
d aot
cbarn
draw title OMI AOT 
printim aot_OMI.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura/OMAERUV/c180R_v202_aura.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs 0 0.5 1 1.5 2 2.5
d maskout(maot.2,aot)
cbarn
draw title c180R_v202_aura AOT 
printim aot_aura.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_nosoa/OMAERUV/c180R_v202_aura_nosoa.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs 0 0.5 1 1.5 2 2.5
d maskout(maot.3,aot)
cbarn
draw title c180R_v202_aura_nosoa AOT 
printim aot_aura_nosoa.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_gsfun/OMAERUV/c180R_v202_aura_gsfun.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs 0 0.5 1 1.5 2 2.5
d maskout(maot.4,aot)
cbarn
draw title c180R_v202_aura_gsfun AOT 
printim aot_aura_gsfun.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_aura_schill/OMAERUV/c180R_v202_aura_schill.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs 0 0.5 1 1.5 2 2.5
d maskout(maot.5,aot)
cbarn
draw title c180R_v202_aura_schill AOT 
printim aot_aura_schill.20160903.png white

c
sdfopen /misc/prc18/colarco/c180R_v202_ceds/OMAERUV/c180R_v202_ceds.OMI-Aura_L2-OMAERUV_2016m0903.grid.nc4
set clevs 0 0.5 1 1.5 2 2.5
d maskout(maot.6,aot)
cbarn
draw title c180R_v202_ceds AOT 
printim aot_ceds.20160903.png white

c
d maskout(maot.2-maot.3,aot)
cbarn
draw title AOT: aura - aura_nosoa
printim aot_diff_v_nosoa.20160903.png white

c
d maskout(maot.2-maot.4,aot)
cbarn
draw title AOT: aura - aura_gsfun
printim aot_diff_v_gsfun.20160903.png white

c
d maskout(maot.4-maot.5,aot)
cbarn
draw title AOT: aura_gsfun - aura_schill
printim aot_diff_gsfun_v_schill.20160903.png white

c
d maskout(maot.4-maot.6,aot)
cbarn
draw title AOT: aura_gsfun - ceds
printim aot_diff_gsfun_v_ceds.20160903.png white
