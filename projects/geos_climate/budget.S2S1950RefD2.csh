#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

foreach expname ( S2S1950RefD2)
set expid    = $expname
set expctl   = $expid.ddf

set year = 1950

while ($year < 1952)

foreach aertype (NI DU SS POM BC SU) #TOT )

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
