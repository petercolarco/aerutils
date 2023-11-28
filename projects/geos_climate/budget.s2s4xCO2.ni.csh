#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

foreach expname ( S2S1850CO2x4pl)
set expid    = $expname
set expctl   = $expid.ddf

set year = 1990

while ($year < 2000)

#foreach aertype (NI DU SS POM BC SU) #TOT )
foreach aertype (NI)

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
