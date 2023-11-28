#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`


<<<<<<< budget.csh
foreach expname (c180R_pI33p9s12_volc )
set expid    = $expname.tavg2d_aer_x
set expctl   = $expid.ctl

foreach year ( 2019 ) #2007 2008 2009 2010 2011 2012 2013 2014 2015 2016)

foreach aertype (BRC DU SS POM BC SU NI ) #TOT )
=======
foreach expname ( merra2.d5124_m2_jan79 ) 
set expid    = $expname.tavg1_2d_aer_Nx
set expctl   = $expid.ddf

foreach year ( 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 )

foreach aertype (POM BC SU DU SS ) #TOT )
#foreach aertype (DU SS)
#foreach aertype ( SUV)
>>>>>>> 1.7

cat > idlscript.$rand << EOF
plot_budget, '$expctl', '$expid', '$aertype', '$year'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand

end

end

end
