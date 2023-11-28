#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  foreach expid ( bF_F25b9-base-v8 bF_F25b9-base-v10 )

  set inpdir = /misc/prc14/colarco/$expid/tavg2d_carma_x/
  set outdir = $inpdir

  foreach years ( 2011 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 )

  ./extract_stations.x -rc sfcobs_locs.dat \
    -i $inpdir/Y%y4/M%m2/$expid.tavg2d_carma_x.monthly.%y4%m2.nc4 \
    -o $outdir/$expid.tavg2d_carma_x.obs.%s.%y4.nc4 \
    -e $expid \
    -nymd ${years}0115 -nhms 120000 -lastnymd ${years}1231 -monthly

  end


end
