#!/bin/csh
# Colarco, November 2010
# This code will read the aeronet_locs.dat files present and perform extractions
# on a pointed too data set (specified by a grads template)

# Make sure extract_stations.x is in your path

# Note that extract_stations.x does not have a good deal of flexibility in time
# extractions at present.

  set expid  = e540_fp
  set inpdir = /misc/prc11/dao_ops/$expid/das/
  set outdir = $inpdir

  set varsext = DUEXTTAU,SSEXTTAU,SUEXTTAU,BCEXTTAU,OCEXTTAU
#  set varssca = DUSCATAU,SSSCATAU,SUSCATAU,BCSCATAU,OCSCATAU
#  set varscol = DUCMASS,SSCMASS,BCCMASS,OCCMASS,SO4CMASS,SO2CMASS
#  set varssfc = DUSMASS,SSSMASS,BCSMASS,OCSMASS,SO4SMASS,SO2SMASS

#  set vars    = $varsext,$varssca,$varscol,$varssfc

  foreach years ( 2010 )

  extract_stations.x -rc aeronet_locs.dat \
    -i $inpdir/Y%y4/M%m2/D%d2/$expid.inst1_2d_hwl_Nx.%y4%m2%d2_%h200z.nc4 \
    -o $outdir/$expid.inst1_2d_hwl_Nx.aeronet.%s.%y4%m2%d2.nc4 \
    -e $expid \
    -nymd 20100601 -nhms 000000 -timestep 010000 -lastnymd 20100831 \
    -vars $varsext


  end
