* Annual cycle of dust emissions
xdfopen ../ctl/b_F25b9-base-v1.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v1.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v5.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v6.tavg2d_carma_x.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v7.tavg2d_carma_x.annual.ctl

set t 8 48
set x 1
set y 1

x1 = aave(duexttau,g)
x2 = aave(duexttau.2,g)
x3 = aave(duexttau.3,g)
x4 = aave(duexttau.4,g)
x5 = aave(duexttau.5,g)

set grads off
set vrange 0.015 0.035
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
d x 3
set ccolor 2
set cstyle 1
d x4

draw title Dust AOT (annual)
plotpng duexttau.png
