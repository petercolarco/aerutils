#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( c180R_H53-acma )
set expid    = $expname.tavg2d_aer_x
set expctl   = $expid.ctl

foreach year ( 2008 )

#foreach aertype (DU SS POM BC SU NI)
foreach aertype (DU SS)
#foreach aertype ( SUV)

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', wantlon=[-20,75], wantlat=[0,50], region='africa'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
