#!/bin/csh
setenv PYTHONPATH ./://home/colarco/sandbox/GAAS/Linux/lib/Python://home/colarco/sandbox/GAAS/Linux/lib/Python/pyobs://home/colarco/sandbox/GAAS/Linux/lib/Python/pyods:$PYTHONPATH

set EXPID = 2011_a2_apport_frland_7
cd /home/colarco/sandbox/GAAS/src/Components/scat/adriana

foreach MM (07)

  set OUTPATH = ./
  mkdir $OUTPATH
  sed 's#EXPID#'$EXPID'#g;s#OUTPATH#'$OUTPATH'#g' sample_omaeruv.tmp > sample_omaeruvFull_.py
  chmod 744 sample_omaeruvFull_.py
  foreach file (`\ls -1 /misc/prc19/colarco/OMAERUV_V187_DATA/2011/OMI-Aura_L2-OMAERUV_2011m${MM}*he5`)
   echo $file
   ./sample_omaeruvFull_.py -F --verbose $file inst3d_aer_v.ddf
  end

end
