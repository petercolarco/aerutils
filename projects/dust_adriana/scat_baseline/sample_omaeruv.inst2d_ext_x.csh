#!/bin/csh
set EXPID = dR_MERRA-AA-r2-v1621
cd /home/colarco/sandbox/GAAS/src/Components/scat/${EXPID}_Full

foreach MM (06 07 08 09 10)

  set OUTPATH = /misc/prc20/colarco/$EXPID/inst2d_aer_x/v1_5/
  mkdir -p $OUTPATH
  sed 's#EXPID#'$EXPID'#g;s#OUTPATH#'$OUTPATH'#g' sample_omaeruv.inst2d_ext_x.tmp > sample_omaeruv_.py
  chmod 744 sample_omaeruv_.py
  foreach file (`\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m${MM}*he5`)
   echo $file
   ./sample_omaeruv_.py -F --verbose $file inst2d_ext_x.ddf
  end

end
