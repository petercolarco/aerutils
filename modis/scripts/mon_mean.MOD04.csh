#!/bin/csh -x
# Colarco, March 2006
# Use the hacked version of lats4d to sample both the model and the satellite to
# arrive at model monthly mean aot based on satellite sampling.

# Result is specific to the particular satellite compared to
# Result can easily be modified to give, e.g., daily means
# The version of lats4d here is seriously hacked and will not generally work!

# Here we sample on the local time of the model

  set maxdays = (31 28 31 30 31 30 31 31 30 31 30 31)
  set mon = (jan feb mar apr may jun jul aug sep oct nov dec)
  set expid = "t003_c32"
  set satellite = "MOD04"


  foreach yyyy (2004)
   foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

    foreach type (lnd ocn)
     set ndays = $maxdays[$mm]
     if( ($yyyy == 2000 || $yyyy == 2004) && $mm == 02) set ndays = 29

     @ ntime = 4 * $ndays

cat > model6.ddf << EOF
dset /output/colarco/$expid/tau/Y%y4/M%m2/$expid.tau2d.%y4%m2%d2.hdf
options template
tdef time $ntime linear 0z01$mon[$mm]$yyyy 6hr
EOF

cat > satellite6.ddf << EOF
#dset /output/colarco/MODIS/Level3/b/GRITAS/Y%y4/M%m2/${satellite}_L2_${type}.aero_004.%y4%m2%d2.hdf
#dset /output/colarco/MODIS/Level3/GRITAS/Y%y4/M%m2/${satellite}_L2_${type}.aero_004.%y4%m2%d2.hdf
#dset /output/colarco/MODIS/Level3/$satellite/GRITAS/Y%y4/M%m2/${satellite}_L2_${type}.aero_004.%y4%m2%d2.hdf
dset /output/MODIS/Level3/$satellite/GRITAS/Y%y4/M%m2/${satellite}_L2_${type}.aero_005.%y4%m2%d2.hdf
options template
tdef time $ntime linear 0z01$mon[$mm]$yyyy 6hr
EOF

   lats4d_ -i model6.ddf -o test 
   mv -f test.nc /output/colarco/$expid/tau/Y$yyyy/M$mm/$expid.tau2d.${satellite}_005.$type.$yyyy$mm.hdf

   end
  end

  end
