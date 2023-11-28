#!/bin/csh
set EXPID = dR_F25b18

setenv PYTHONPATH ./:/misc/prc08/colarco/GAAS/Linux/lib/Python:$PYTHONPATH

foreach alt ( "lift_2km" "lift_3km" "lift_4km" "lift_5km")

  sed 's#ALT#'$alt'#g' inst3d_aer_v.tmp > inst3d_aer_v.ddf

  set OUTPATH = /misc/prc14/colarco/$EXPID/inst3d_aer_v/$alt
  sed 's#EXPID#'$EXPID'#g;s#OUTPATH#'$OUTPATH'#g' sample_omaeruv.tmp > sample_omaeruv_.py
  chmod 744 sample_omaeruv_.py
  foreach file (`\ls -1 /science/aura/OMI/data/L2/aeruv/2007/OMI-Aura_L2-OMAERUV_2007m0904*he5`)
  echo $file
  ./sample_omaeruv_.py --verbose $file inst3d_aer_v.ddf
  end

end
