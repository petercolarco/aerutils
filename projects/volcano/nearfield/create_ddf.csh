#!/bin/tcsh
#Create DDF for simulations

foreach file (`\ls -d */`)

set expid = `echo $file:h`
set mon   = `echo $expid | cut -c 6-8`

cat > $expid.tavg2d_aer_x.ddf <<EOF
dset /misc/prc18/colarco/volcano/$file/tavg2d_aer_x/Y2015/$expid.tavg2d_aer_x.%y4%m2%d2_%h230z.nc4
options template
tdef time 360 linear 01:30z15${mon}2015 3hr
EOF

cat > $expid.tavg2d_carma_x.ddf <<EOF
dset /misc/prc18/colarco/volcano/$file/tavg2d_carma_x/Y2015/$expid.tavg2d_carma_x.%y4%m2%d2_%h230z.nc4
options template
tdef time 360 linear 01:30z15${mon}2015 3hr
EOF

end
