#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( CCMI_REF_C2 )
set expid    = $expname
set expctl   = $expid.ddf

foreach year ( 1970 1980 1990 2000 2010 2020 2030 2040 2050 \
               2060 2070 2080 2090 2100 )

foreach aertype (DU SS POM BC SU)
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
