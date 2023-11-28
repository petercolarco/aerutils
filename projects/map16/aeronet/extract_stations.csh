#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set wrkdir = `pwd`

  foreach expid (MERRA2)
  set inpdir = /misc/prc13/$expid/tavg1_2d_aer_Nx/
  set outdir = $inpdir

  set varsext = DUEXTTAU,SSEXTTAU,SUEXTTAU,BCEXTTAU,OCEXTTAU
  set varssca = DUSCATAU,SSSCATAU,SUSCATAU,BCSCATAU,OCSCATAU
  set varscol = DUCMASS,SSCMASS,BCCMASS,OCCMASS,SO4CMASS,SO2CMASS
  set varssfc = DUSMASS,SSSMASS,BCSMASS,OCSMASS,SO4SMASS,SO2SMASS
  set varstot = TOTEXTTAU,TOTSCATAU,TOTANGSTR

  set vars    = $varsext#,$varssca,$varscol,$varssfc,$varstot

  foreach years ( 2013 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2014 2015)

  set expid_ = MERRA2_400
  if( $years < 2010 ) set expid_ = MERRA2_300

  extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/Y%y4/M%m2/${expid_}.tavg1_2d_aer_Nx.%y4%m2%d2.nc4 \
    -o $outdir/aeronet/$expid.tavg1_2d_aer_Nx.aeronet.%s.%y4.nc4 \
    -e $expid \
    -vars $vars \
    -nymd ${years}0101 -nhms 003000 -timestep 010000 -lastnymd ${years}0102

  end

end

