#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

foreach expname ( C90c_HTcntl)
set expid    = $expname
set expctl   = $expid.aer_monthly.ctl

set year = 2022

while ($year < 2023)

#foreach aertype (NI DU SS POM BC SU) #TOT )
foreach aertype (SU)

set rand = `ps -A | sum | cut -c1-5`

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

@ year = $year + 1

end

end
