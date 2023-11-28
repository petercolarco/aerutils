xdfopen omaeruv.ddf
xdfopen c180R_v202_aura_gsfun.ddf

set lon -30 40
set lat -40 20

set gxout grfill

xycomp ai ai.2

printim ai.difference.png white

c
xycomp aot maskout(maot.2,maot.2-0.01)
printim aot.difference.png white

c
xycomp ssa maskout(mssa.2,mssa.2-0.7)
printim ssa.difference.png white
