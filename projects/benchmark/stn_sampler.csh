#!/bin/csh
  setenv PYTHONPATH ./:/share/colarco/GAAS/Linux/lib/Python:/share/colarco/GAAS/Linux/lib/Python/pyobs:/share/colarco/GAAS/Linux/lib/Python/pyods#:/usr/lib/portage/pym:/share/dasilva/epd/gaas/epd-7.3-2-rh5-x86_64:

  set varsext = DUEXTTAU,SSEXTTAU,SUEXTTAU,BCEXTTAU,OCEXTTAU,BRCEXTTAU,NIEXTTAU
  set varssca = DUSCATAU,SSSCATAU,SUSCATAU,BCSCATAU,OCSCATAU,BRCSCATAU,NISCATAU
#  set varscol = DUCMASS,SSCMASS,BCCMASS,OCCMASS,SO4CMASS,SO2CMASS
#  set varssfc = DUSMASS,SSSMASS,BCSMASS,OCSMASS,SO4SMASS,SO2SMASS
  set varstot = TOTEXTTAU,TOTSCATAU,TOTANGSTR

  set vars    = $varsext,$varstot

  foreach YYYY (2019 )

  set outfile = /misc/prc18/colarco/c180R_pI33p9s12_volc/c180R_pI33p9s12_volc.inst2d_hwl_x.aeronet.$YYYY.nc4

  ./stn_sampler.py -v -V $vars aeronet_locations_v3.txt c180R_pI33p9s12_volc.ddf \
                         ${YYYY}-01-01T00:00:00 ${YYYY}-12-31T23:00:00

  \mv -f stn_sampler.nc $outfile


  end
