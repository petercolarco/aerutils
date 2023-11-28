* Clim cycle of dust emissions
xdfopen ../ctl/b_F25b9-base-v1.tavg2d_carma_x.clim.ctl
xdfopen ../ctl/bF_F25b9-base-v1.tavg2d_carma_x.clim.ctl
xdfopen ../ctl/bF_F25b9-base-v5.tavg2d_carma_x.clim.ctl
xdfopen ../ctl/bF_F25b9-base-v6.tavg2d_carma_x.clim.ctl
xdfopen ../ctl/bF_F25b9-base-v7.tavg2d_carma_x.clim.ctl

set t 1 12
set lon -22
set lat 16

x1 = duexttau
x2 = duexttau.2
x3 = duexttau.3
x4 = duexttau.4
x5 = duexttau.5

set grads off
set vrange 0 1
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

draw title Dust AOT (Capo Verde)
plotpng capo_verde.png
