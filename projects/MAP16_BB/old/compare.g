sdfopen /misc/prc14/colarco/GFED/gfedv4_1s.emis_bc.x1152_y721_t240.19970115_12z_20161215_12z.nc
sdfopen /misc/prc14/colarco/MAP16_BB/clm4_5.emis_bc.x576_y361_t444.19800115_12z_20161215_12z.nc
set x 1
set y 1
set t 37 108
bc1 = aave(biomass,g)*86400*30*5.1e5
set dfile 2
set x 1
set y 1
set t 241 312
bc2 = aave(biomass.2,g)*86400*30*5.1e5
d bc2
d bc1
draw title BC emissions [Tg mon-1], CLM (black), GFEDv4.1s (green)
printim bcem.png white

reinit
sdfopen /misc/prc14/colarco/GFED/gfedv4_1s.emis_oc.x1152_y721_t240.19970115_12z_20161215_12z.nc
sdfopen /misc/prc14/colarco/MAP16_BB/clm4_5.emis_oc.x576_y361_t444.19800115_12z_20161215_12z.nc
set x 1
set y 1
set t 37 108
bc1 = aave(biomass,g)*86400*30*5.1e5
set dfile 2
set x 1
set y 1
set t 241 312
bc2 = aave(biomass.2,g)*86400*30*5.1e5
d bc2
d bc1
draw title OC emissions [Tg mon-1], CLM (black), GFEDv4.1s (green)
printim ocem.png white


reinit
sdfopen /misc/prc14/colarco/GFED/gfedv4_1s.emis_so2.x1152_y721_t240.19970115_12z_20161215_12z.nc
sdfopen /misc/prc14/colarco/MAP16_BB/clm4_5.emis_so2.x576_y361_t444.19800115_12z_20161215_12z.nc
set x 1
set y 1
set t 37 108
bc1 = aave(biomass,g)*86400*30*5.1e5
set dfile 2
set x 1
set y 1
set t 241 312
bc2 = aave(biomass.2,g)*86400*30*5.1e5
d bc2
d bc1
draw title SO2 emissions [Tg mon-1], CLM (black), GFEDv4.1s (green)
printim so2em.png white

reinit
sdfopen /misc/prc14/colarco/GFED/gfedv4_1s.emis_nh3.x1152_y721_t240.19970115_12z_20161215_12z.nc
sdfopen /misc/prc14/colarco/MAP16_BB/clm4_5.emis_nh3.x576_y361_t444.19800115_12z_20161215_12z.nc
set x 1
set y 1
set t 37 108
bc1 = aave(biomass,g)*86400*30*5.1e5
set dfile 2
set x 1
set y 1
set t 241 312
bc2 = aave(biomass.2,g)*86400*30*5.1e5
d bc2
d bc1
draw title NH3 emissions [Tg mon-1], CLM (black), GFEDv4.1s (green)
printim nh3em.png white


reinit
sdfopen /misc/prc14/colarco/GFED/gfedv4_1s.emis_co2.x1152_y721_t240.19970115_12z_20161215_12z.nc
sdfopen /misc/prc14/colarco/MAP16_BB/clm4_5.emis_co2.x576_y361_t444.19800115_12z_20161215_12z.nc
set x 1
set y 1
set t 37 108
bc1 = aave(biomass,g)*86400*30*5.1e5
set dfile 2
set x 1
set y 1
set t 241 312
bc2 = aave(biomass.2,g)*86400*30*5.1e5
d bc2
d bc1
draw title CO2 emissions [Tg mon-1], CLM (black), GFEDv4.1s (green)
printim co2em.png white


reinit
sdfopen /misc/prc14/colarco/GFED/gfedv4_1s.emis_co.x1152_y721_t240.19970115_12z_20161215_12z.nc
sdfopen /misc/prc14/colarco/MAP16_BB/clm4_5.emis_co.x576_y361_t444.19800115_12z_20161215_12z.nc
set x 1
set y 1
set t 37 108
bc1 = aave(biomass,g)*86400*30*5.1e5
set dfile 2
set x 1
set y 1
set t 241 312
bc2 = aave(biomass.2,g)*86400*30*5.1e5
d bc2
d bc1
draw title CO emissions [Tg mon-1], CLM (black), GFEDv4.1s (green)
printim coem.png white
