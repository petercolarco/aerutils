#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set expid  = M2R12K
  set inpdir = /misc/prc13/${expid}_BETA7/M2R12K_may2005/DATA/0.5000_deg/inst/inst1_2d_hwl_Cx/
  set outdir = $inpdir

  set varsext = DUEXTTAU,SSEXTTAU,SUEXTTAU,BCEXTTAU,OCEXTTAU
  set varssca = DUSCATAU,SSSCATAU,SUSCATAU,BCSCATAU,OCSCATAU
  set varscol = DUCMASS,SSCMASS,BCCMASS,OCCMASS,SO4CMASS,SO2CMASS
  set varssfc = DUSMASS,SSSMASS,BCSMASS,OCSMASS,SO4SMASS,SO2SMASS
  set varstot = TOTEXTTAU,TOTSCATAU,TOTANGSTR,SLP

  set vars    = $varsext,$varssca,$varscol,$varssfc
  set vars    = $varsext,$varssfc,$varstot

  foreach years ( 2007)

  extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/Y%y4/M%m2/D%d2/$expid.inst1_2d_hwl_Cx.%y4%m2%d2_%h200z.nc4 \
    -o $outdir/aeronet/$expid.inst2d_hwl.aeronet.%s.%y4.nc4 \
    -e $expid \
    -vars $vars \
    -nymd ${years}0101 -nhms 000000 -timestep 010000 -lastnymd ${years}1231

  end
