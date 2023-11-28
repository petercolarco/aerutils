foreach expid (c180R_v202_aura_asoc c180R_v202_aura_gsfun c180R_v202_aura_low c180R_v202_aura_nobc c180R_v202_aura_nobrc c180R_v202_aura_nosu c180R_v202_aura_nodu c180R_v202_aura_nosoa c180R_v202_aura_schill)

reinit
xdfopen $expid.ddf
set t 3
set lon -20 50
set lat -40 5
set mpdset hires
set grads off
set gxout grfill

xycomp maskout(mssa,ssa) ssa
printim ssa.$expid.omaeruv.20160903.png white

end
