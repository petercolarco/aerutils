#!/bin/tcsh
#Create DDF for simulations

foreach file (`\ls -d */`)

set expid = `echo $file:h`
set mon   = `echo $expid | cut -c 6-8`

cat > $expid.tavg3d_aer_p.ddf <<EOF
dset /misc/prc20/colarco/volcano/GEOS5/$file/tavg3d_aer_p/Y2015/$expid.tavg3d_aer_p.%y4%m2%d2_%h200z.nc4
options template
tdef time 60 linear 09z15${mon}2015 24hr
EOF

cat > $expid.tavg3d_carma_p.ddf <<EOF
dset /misc/prc20/colarco/volcano/GEOS5/$file/tavg3d_carma_p/Y2015/$expid.tavg3d_carma_p.%y4%m2%d2_%h200z.nc4
options template
tdef time 60 linear 09z15${mon}2015 24hr
EOF

end
