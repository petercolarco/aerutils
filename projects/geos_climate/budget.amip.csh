#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( AMIP1850CO2x4)
set expid    = $expname
set expctl   = $expid.ddf

foreach year ( 1850)
#     1851 1852 1853 1854 1855 1856 1857 1858 1859 \
#               1860 1861 1862 1863 1864 1865 1866 )

#           1862 1863 1864 1865 1866 1867 1868 1869 \
#               1870 1871 1872 1873 1874 1875 1876 1877 1878 1879)

foreach aertype (NI DU SS POM BC SU) #TOT )

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year', /oldscav
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
