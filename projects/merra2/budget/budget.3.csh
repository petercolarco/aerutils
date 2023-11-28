#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( merra2.d5124_m2_jan10 ) 
set expid    = $expname.tavg1_2d_aer_Nx
set expctl   = $expid.ddf

foreach year ( 2011 )

foreach aertype (POM BC SU DU SS ) #TOT )
#foreach aertype (DU SS)
#foreach aertype ( SUV)

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
