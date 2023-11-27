#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( c180R_pI33)
set expid    = d5124_m2_jan79
set expctl   = $expid.ddf

foreach year ( 2016)

foreach aertype (DU SS POM BC SU ) #TOT )

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
