#!/bin/csh
set EXPID = c360Fc_asdI10_pin
cd /home/colarco/sandbox/aerutils/projects/pinatubo/scat/c360

  set OUTPATH = ./
  sed 's#EXPID#'$EXPID'#g;s#OUTPATH#'$OUTPATH'#g' sample_omaeruv.tmp > sample_omaeruvFull_.py
  chmod 744 sample_omaeruvFull_.py
  foreach file (`\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m061[7]t22*he5`)
   echo $file
   ./sample_omaeruvFull_.py -F --verbose $file inst3d_carma_v.ddf
  end
