#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots


foreach expname ( RefD1)
set expid    = $expname
set expctl   = $expid.tavg2d_aer_x.ctl

set year = 1975

while ($year < 1980)

#foreach aertype (NI DU SS POM BC SU) #TOT )
foreach aertype (SUV)

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /oldscav
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

@ year = $year + 1

end

end
