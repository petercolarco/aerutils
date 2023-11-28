#!/bin/csh -f
# Colarco, January 2006
# Run the IDL code to generate the monthly budget plots

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

foreach expname ( bF_F25b9-base-v1 bF_F25b9-base-v5 bF_F25b9-base-v6 bF_F25b9-base-v7 )


set expid    = $expname.geosgcm_surf
set expctl   = $expid.ctl


foreach year ( 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 )

cat > idlscript.$rand << EOF
plot_forcing, '$expctl', '$expid', '$year', \$
wantlon=[-60,35], wantlat=[0,40], region='sahara'
exit
EOF

  idl idlscript.$rand
  rm -f idlscript.$rand


end

end
