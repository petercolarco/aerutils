#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

#foreach expname ( b_F25b9-base-v1 bF_F25b9-base-v1 bF_F25b9-base-v6 bF_F25b9-base-v5 bF_F25b9-base-v7 bF_F25b9-base-v8 bF_F25b9-base-v10 bF_F25b9-base-v11)
foreach expname ( b_F25b9-base-v1 )

set expid    = $expname.tavg2d_carma_x
set expctl   = $expid.ctl


#foreach year ( 2026 2027 2028 2029 2030 2031 2032 2033 2034 2035 \
#               2036 2037 2038 2039 2040 2041 2042 2043 2044 2045 \
#               2046 2047 2048 2049 2050 )
foreach year (2011 2012)
foreach aertype (DU)

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /carma, \$
wantlon=[-60,35], wantlat=[0,40], region='sahara'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
