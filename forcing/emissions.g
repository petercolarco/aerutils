* Annual cycle of dust emissions
xdfopen ../ctl/b_F25b9-base-v1.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v1.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v5.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v6.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v7.tavg2d_carma_x.annual.ctl

set t 8 48
set x 1
set y 1

x1 = aave(duem,g)*5.1e5*365*86400
x2 = aave(duem.2,g)*5.1e5*365*86400
x3 = aave(duem.3,g)*5.1e5*365*86400
x4 = aave(duem.4,g)*5.1e5*365*86400
x5 = aave(duem.5,g)*5.1e5*365*86400

set grads off
set vrange 1800 2500
set cthick 12
set ccolor 3
d x1

set ccolor 1
d x2
set ccolor 1
set cstyle 2
d x5

set cstyle 2
set ccolor 2
d x3
set ccolor 2
set cstyle 1
d x4

draw title Dust Emissions (annual, Tg)
plotpng emissions.png
