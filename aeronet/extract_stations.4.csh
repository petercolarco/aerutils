#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set expid  = R_dead_u10n
  set inpdir = /misc/prc11/colarco/$expid/tavg2d_ext_x/
  set outdir = $inpdir

  foreach years ( 2008 )

  extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/Y%y4/M%m2/$expid.tavg2d_ext_x.%y4%m2%d2_%h230z.nc4 \
    -o $outdir/$expid.tavg2d_ext_x.aeronet.%s.%y4.nc4 \
    -e $expid \
    -nymd ${years}0101 -nhms 013000 -timestep 030000 -lastnymd ${years}1231

  end
