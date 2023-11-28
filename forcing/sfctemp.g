* Annual cycle of dust emissions
xdfopen ../ctl/b_F25b9-base-v1.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v1.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v5.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v6.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v7.geosgcm_surf.annual.ctl

set t 8 23
set x 1
set y 1

x1 = aave(t2m,g)
x2 = aave(t2m.2,g)
x3 = aave(t2m.3,g)
x4 = aave(t2m.4,g)
x5 = aave(t2m.5,g)

set grads off
set vrange 286.9 287.3
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

draw title Surface Temperature (annual)
plotpng sfctemp.png
