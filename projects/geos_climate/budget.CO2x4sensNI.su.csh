#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

foreach expname ( CO2x4sensNI)
set expid    = $expname
set expctl   = $expid.ddf

set year = 1995

while ($year < 2000)

#foreach aertype (NI DU SS POM BC SU) #TOT )
foreach aertype (SU)

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
