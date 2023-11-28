#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

foreach expname ( c48F_G40b11_ocs)

set expid    = $expname.tavg2d_carma_x
set expctl   = $expid.ddf

foreach year (1993 1994 1995 1996 1997)

foreach aertype (OCS)

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /carma
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
