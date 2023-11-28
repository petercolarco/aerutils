#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

<<<<<<< carma.csh
#foreach expname ( d_F25b9-base-v1 ) # dF_F25b9-base-v1 )
foreach expname ( c48F_J32_carma_ex4)
#foreach expname (bF_G40b10-kok-v15)
=======
#foreach expname ( d_F25b9-base-v1 ) # dF_F25b9-base-v1 )
foreach expname ( c48R_G40_cduss)
#foreach expname (bF_G40b10-kok-v15)
>>>>>>> 1.2

set expid    = $expname.tavg2d_carma_x
set expctl   = $expid.ctl

<<<<<<< carma.csh
foreach year (2006)

#foreach year ( 2011 2012 2013 2014 2015 2016 2017 2018 2019 \
#               2021 2022 2023 2024 2025 2026 2027 2028 2029 \
#               2031 2032 2033 2034 2035 2036 2037 2038 2039 \
#               2041 2042 2043 2044 2045 2046 2047 2048 2049 2050 )
=======
foreach year (2007)

#foreach year ( 2011 2012 2013 2014 2015 2016 2017 2018 2019 \
#               2021 2022 2023 2024 2025 2026 2027 2028 2029 \
#               2031 2032 2033 2034 2035 2036 2037 2038 2039 \
#               2041 2042 2043 2044 2045 2046 2047 2048 2049 2050 )
>>>>>>> 1.2

<<<<<<< carma.csh
foreach aertype (SU DU SM SS)
=======
foreach aertype (DU SS)
>>>>>>> 1.2

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /carma
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
