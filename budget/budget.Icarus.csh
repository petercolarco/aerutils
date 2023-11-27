#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname (c180F_J10p17p0chl )
set expid    = $expname.tavg2d_aer_x
set expctl   = $expid.ctl

foreach year ( 2014 )

foreach aertype (DU SS POM BC SU NI ) #BRC #TOT )

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /oldscav
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
