#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( c48R_G40b11_0209 )
#foreach expname ( 25b20geo02 )
set expid    = $expname.tavg2d_aer_x
set expctl   = $expid.ctl

foreach year ( 2003 2004 2005 2006 2007 )

foreach aertype (POM)
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
