#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

foreach expname ( dR_MERRA-AA-r2)

set expid    = $expname.tavg2d_aer_x
set expctl   = $expid.ctl


foreach year ( 2011 )
foreach aertype (TOT DU SS SU POM BC)


cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', \$
wantlon=[-60,60], wantlat=[-30,30], region='safrica'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
