#!/bin/csh
  setenv EPDVERSION epd-7.3-2-rh5-x86_64
  source /misc/prc00/colarco/epd/epd_vars.csh
  setenv PYTHONPATH ./:/home/colarco/sandbox/GAAS/Linux/lib/Python:/home/colarco/sandbox/GAAS/Linux/lib/Python/pyobs:/home/colarco/sandbox/GAAS/Linux/lib/Python/pyods:/usr/lib/portage/pym#:$PYTHONPATH

set EXPID = dR_MERRA-AA-r2-v1621
cd /home/colarco/sandbox/GAAS/src/Components/scat/${EXPID}_Full

foreach MM (06)

  set OUTPATH = /misc/prc20/colarco/$EXPID/inst3d_aer_v/Y2007/M$MM
  mkdir $OUTPATH
  sed 's#EXPID#'$EXPID'#g;s#OUTPATH#'$OUTPATH'#g' sample_omaeruv_u10m.tmp > sample_omaeruvFull_u10m.py
  chmod 744 sample_omaeruvFull_u10m.py

  foreach file (`\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m${MM}*he5`)
   echo $file
   ./sample_omaeruvFull_u10m.py -F --verbose $file inst3d_aer_v.ddf geosgcm_surf.ddf
  end

end
