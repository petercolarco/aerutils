#!/bin/tcsh
#foreach expid (omaeruv)

## masking on the valid OMI AOT retrievals
#  lats4d.sh -v -i $expid.ddf -o $expid.monthly.201609 -ftype xdf -mean \
#            -vars ai aot ssa \
#            -func "maskout(@,aot)"
#  lats4d.sh -i $expid.monthly.201609.nc -o $expid.monthly.201609 -shave
#  rm -f $expid.monthly.201609.nc

#end


foreach expid ( c360R_era5_v10p22p2_aura_loss_bb3_low3 c360R_era5_v10p22p2_aura_baseline c360R_era5_v10p22p2_aura_baseline_gaas)
#c180R_v202_aura_nosoa c180R_v202_aura_schill)
#foreach expid (c180R_v202_aura_asoc c180R_v202_aura_gsfun c180R_v202_aura_low \
#               c180R_v202_aura_nobc c180R_v202_aura_nobrc c180R_v202_aura_nodu \
#               c180R_v202_aura_nosoa c180R_v202_aura_nosu c180R_v202_aura_schill)

# masking on the valid OMI AOT retrievals
  lats4d.sh -v -i $expid.ddf -o $expid.monthly.201609 -ftype xdf -mean \
#            -vars ai maot mssa aot ssa \
            -func "maskout(maskout(@,mssa-0.7),aot)"
  lats4d.sh -i $expid.monthly.201609.nc -o $expid.monthly.201609 -shave
  rm -f $expid.monthly.201609.nc

end
