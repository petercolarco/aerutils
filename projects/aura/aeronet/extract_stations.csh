#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set wrkdir = `pwd`

  foreach expid (dR_MERRA-AA-r2)
  foreach ver   (v11_5)# v7_5)
  set inpdir = /misc/prc15/colarco/$expid/inst2d_aer_x/$ver/
  set outdir = $inpdir

  set vars    = totexttau,totabstau

  mkdir -p $inpdir/aeronet

  extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/$expid.inst2d_totexttau_x.%y4%m2%d2_%h200z.nc4 \
    -o $outdir/aeronet/$expid.$ver.inst2d_aer.aeronet.%s.%y4.nc4 \
    -e $expid \
    -vars $vars \
    -nymd 20070601 -nhms 000000 -timestep 030000 -lastnymd 20070930

  end

  end

end

