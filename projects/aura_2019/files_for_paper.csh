#!/bin/tcsh

lats4d.sh -i omaeruv.monthly.201609.nc4 -vars ai -o OMI.monthly.AI
lats4d.sh -i c360R_era5_v10p22p2_aura_baseline.monthly.201609.nc4 -vars ai -o GEOS.baseline.monthly.AI
lats4d.sh -i c360R_era5_v10p22p2_aura_loss_bb3_low3.monthly.201609.nc4 -vars ai -o GEOS.OAloss+updated_optics.monthly.AI

lats4d.sh -i /misc/prc18/colarco/c360R_era5_v10p22p2_aura_baseline/c360R_era5_v10p22p2_aura_baseline.inst2d_hwl_x.monthly.201609.nc4 -vars totexttau -o GEOS.baseline.monthly.AOT
lats4d.sh -i /misc/prc18/colarco/c360R_era5_v10p22p2_aura_baseline/c360R_era5_v10p22p2_aura_baseline.geosgcm_surf.monthly.201609.nc4 -vars cldlo swtnet swtnetna swgnet swgnetna -o GEOS.baseline.monthly.clouds_forcing

lats4d.sh -i /misc/prc18/colarco/c360R_era5_v10p22p2_aura_loss_bb3_low3/c360R_era5_v10p22p2_aura_loss_bb3_low3.inst2d_hwl_x.monthly.201609.nc4 -vars totexttau -o GEOS.OAloss+updated_optics.monthly.AOT
lats4d.sh -i /misc/prc18/colarco/c360R_era5_v10p22p2_aura_loss_bb3_low3/c360R_era5_v10p22p2_aura_loss_bb3_low3.geosgcm_surf.monthly.201609.nc4 -vars cldlo swtnet swtnetna swgnet swgnetna -o GEOS.OAloss+updated_optics.monthly.clouds_forcing
