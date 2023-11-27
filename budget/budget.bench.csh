#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


foreach expname ( bench_10-17-6_gmi_free_c180_72lev )
set expid    = $expname
set expctl   = $expid.ddf

foreach year ( 1999) # 2003 2004 20025 2006 2007 2008 2009 2010 2011 2012 2013)

foreach aertype (NI DU SS POM BC SU) #TOT )

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
