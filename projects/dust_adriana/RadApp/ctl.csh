#!/bin/tcsh

  foreach reg ('full' 'r01' 'r02' 'r03' 'r04' 'r05' \
                      'r06' 'r07' 'r08' 'r09' 'r10' )
  foreach bin ( 0 1 2 3 4 5)
  if ($bin == 0) set filetag = "${reg}_full"
  if ($bin == 1) set filetag = "${reg}_bin1"
  if ($bin == 2) set filetag = "${reg}_bin2"
  if ($bin == 3) set filetag = "${reg}_bin3"
  if ($bin == 4) set filetag = "${reg}_bin4"
  if ($bin == 5) set filetag = "${reg}_bin5"

  cat > $filetag.ddf <<EOF
dset /misc/prc18/colarco/c90R_du_Jasper_run1/inst2d_surf_x/$filetag/inst2d_surf_x/RadApp_I33_${filetag}.inst2d_surf_x.monthly.%y4%m2.nc4
options template
tdef time 60 linear 12z15jan2004 1mo
EOF


  end

end
