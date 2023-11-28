#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set expid  = dR_MERRA-AA-r2
  set inpdir = /misc/prc15/colarco/$expid/inst2d_hwl_x/
  set outdir = $inpdir

  set vars    = totexttau,totscatau,totangstr

  foreach years ( 2003 )

  ./extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/Y%y4/M%m2/$expid.inst2d_hwl_x.%y4%m2%d2_%h200z.nc4 \
    -o $outdir/$expid.inst2d_hwl.aeronet.%s.%y4.nc4 \
    -e $expid \
    -vars $vars \
    -nymd ${years}0101 -nhms 000000 -timestep 010000 -lastnymd ${years}0102


  end
