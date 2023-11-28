* Annual cycle of dust emissions
xdfopen ../ctl/b_F25b9-base-v1.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v1.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v5.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v6.geosgcm_surf.annual.ctl
xdfopen ../ctl/bF_F25b9-base-v7.geosgcm_surf.annual.ctl

set t 8 23
set x 1
set y 1

x1 = aave(lsprcp+anprcp+cnprcp,g) * 86400
x2 = aave(lsprcp.2+anprcp.2+cnprcp.2,g) * 86400
x3 = aave(lsprcp.3+anprcp.3+cnprcp.3,g) * 86400
x4 = aave(lsprcp.4+anprcp.4+cnprcp.4,g) * 86400
x5 = aave(lsprcp.5+anprcp.5+cnprcp.5,g) * 86400

set grads off
set vrange 2.85 2.9
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

draw title Total Precip [mm day-1] (annual)
plotpng precip.png
