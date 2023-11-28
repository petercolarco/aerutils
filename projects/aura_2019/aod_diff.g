foreach expid (c180R_v202_aura_asoc c180R_v202_aura_gsfun c180R_v202_aura_low c180R_v202_aura_nobc c180R_v202_aura_nobrc c180R_v202_aura_nosu c180R_v202_aura_nodu c180R_v202_aura_nosoa c180R_v202_aura_schill)

reinit
sdfopen $expid.monthly.201609.nc4
set lon -20 50
set lat -40 5
set mpdset hires
set grads off
set gxout grfill

xycomp maot aot
printim aod.$expid.omaeruv.monthly.png white

end
