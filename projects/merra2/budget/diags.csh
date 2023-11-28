#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

foreach expname ( R_QFED_22a1 cR_Fortuna-2-4-b4 dR_Fortuna-2-4-b4)

set expid    = $expname.geosgcm_surf
set expctl   = $expid.ctl


foreach year ( 2007 2008 2009 2010)
foreach aertype (DIAG)


cat > idlscript << EOF
;plot_diags, '$expctl', '$expid', '$year', '06'
plot_budget, '$expctl', '$expid', '$aertype', '$year'
exit
EOF

  idl idlscript
  rm -f idlscript

end

end

end
