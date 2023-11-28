sdfopen /share/colarco/GAAS//src/Components/scat/test_badpmom/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2017m0721t025719.vl_rad.geos5_pressure.grid.nc4
sdfopen /share/colarco/GAAS//src/Components/scat/test_newpmom/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2017m0721t025719.vl_rad.geos5_pressure.grid.nc4
sdfopen /share/colarco/GAAS//src/Components/scat/dR_MERRA-AA-r2-v1891_Full/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2017m0721t025719.vl_rad.geos5_pressure.grid.nc4

set gxout grfill
set lon -50 40
set lat -30 40
xycomp maot maot.3
printim aot.newoptics_badpmom-oldoptics_badpmom.png white

c
xycomp maot maot.2
printim aot.newoptics_badpmom-newoptics_newpmom.png white

c
xycomp mssa/maot mssa.3/maot.3
printim ssa.newoptics_badpmom-oldoptics_badpmom.png white

c
xycomp mssa/maot mssa.2/maot.2
printim ssa.newoptics_badpmom-newoptics_newpmom.png white

c
xycomp ai ai.3
printim ai.newoptics_badpmom-oldoptics_badpmom.png white

c
xycomp ai ai.2
printim ai.newoptics_badpmom-newoptics_newpmom.png white
