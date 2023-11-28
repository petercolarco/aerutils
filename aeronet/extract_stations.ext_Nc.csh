#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set expid  = dR_MERRA-AA-r2
  set inpdir = /misc/prc15/colarco/$expid/ext_Nc/
  set outdir = $inpdir

  set vars    = aaod,taod

  foreach years ( 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013)

  ./extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/Y%y4/M%m2/$expid.ext_Nc.%y4%m2%d2_%h200z.nc4 \
    -o $outdir/aeronet/$expid.ext_Nc-v11.aeronet.%s.%y4.nc4 \
    -e $expid \
    -nymd ${years}0101 -nhms 000000 -timestep 030000 -lastnymd ${years}1231 \
    -vars $vars


  end
