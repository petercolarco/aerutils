#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

#foreach expname ( d_F25b9-base-v1 ) # dF_F25b9-base-v1 )
#foreach expname ( bF_G40b10-kok-v15)
foreach expname (c48F_aG40-base-v11 )

set expid    = $expname.tavg2d_carma_x
set expctl   = $expid.ctl


foreach year ( 2019)

foreach aertype (DU SS)

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /carma
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
