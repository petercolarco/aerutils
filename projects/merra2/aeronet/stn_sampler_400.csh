#!/bin/csh
  setenv PYTHONPATH ./:/home/colarco/sandbox/GAAS/Linux/lib/Python:/home/colarco/sandbox/GAAS/Linux/lib/Python/pyobs:/home/colarco/sandbox/GAAS/Linux/lib/Python/pyods:/usr/lib/portage/pym:/share/dasilva/epd/gaas/epd-7.3-2-rh5-x86_64:

  set varsext = DUEXTTAU,SSEXTTAU,SUEXTTAU,BCEXTTAU,OCEXTTAU
  set varssca = DUSCATAU,SSSCATAU,SUSCATAU,BCSCATAU,OCSCATAU
#  set varscol = DUCMASS,SSCMASS,BCCMASS,OCCMASS,SO4CMASS,SO2CMASS
#  set varssfc = DUSMASS,SSSMASS,BCSMASS,OCSMASS,SO4SMASS,SO2SMASS
  set varstot = TOTEXTTAU,TOTSCATAU,TOTANGSTR

  set vars    = $varsext,$varssca,$varstot

  foreach YYYY (2014 2015 2016)

  set outfile = /misc/prc13/MERRA2/aeronet/MERRA2.tavg1_2d_aer_Nx.aeronet.$YYYY.nc4

  ./stn_sampler.py -v -o stn_sampler_400.nc \
                   -V $vars stn_sampler.csv MERRA2_400.ddf \
                         ${YYYY}-01-01T00:30:00 ${YYYY}-12-031T23:30:00

  \mv -f stn_sampler_400.nc $outfile


  end
