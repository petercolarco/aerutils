foreach expid (c180R_v202_aura_asoc c180R_v202_aura_gsfun c180R_v202_aura_low c180R_v202_aura_nobc c180R_v202_aura_nobrc c180R_v202_aura_nosu c180R_v202_aura_nodu c180R_v202_aura_nosoa c180R_v202_aura_schill)

reinit
xdfopen $expid.ddf
set t 20
set lon -30 45
set lat -40 20
set mpdset hires
set grads off
set gxout grfill

set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(mssa,ssa)
cbarn
draw title SSA: $expid
printim ssa.$expid.20160920png white

c
set clevs 0 0.5 1 1.5 2 2.5
d maskout(maot,ssa)
cbarn
draw title AOT: $expid
printim aot.$expid.20160920.png white

c
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai,ssa)
cbarn
draw title AI: $expid
printim ai.$expid.20160920.png white


end

foreach expid (omaeruv)

reinit
xdfopen $expid.ddf
set t 20
set lon -30 45
set lat -40 20
set mpdset hires
set grads off
set gxout grfill

set clevs .8 .82 .84 .86 .88 .9 .92 .94 .96 .98
d maskout(ssa,ssa)
cbarn
draw title SSA: $expid
printim ssa.$expid.20160920.png white

c
set clevs 0 0.5 1 1.5 2 2.5
d maskout(aot,ssa)
cbarn
draw title AOT: $expid
printim aot.$expid.20160920.png white

c
set clevs -0.5 0 .5 1 1.5 2 2.5 3
d maskout(ai,ssa)
cbarn
draw title AI: $expid
printim ai.$expid.20160920.png white


end
