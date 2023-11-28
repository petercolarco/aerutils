xdfopen ../ctl/bF_F25b9-base-v1.geosgcm_prog.ctl
xdfopen ../ctl/bF_F25b9-base-v1.tavg3d_carma_p.ctl

set lon -30
set lat -30 45
set lev 1000 500
set zlog on
set t 18

set gxout shaded
d du.2*airdens.2*1e9
cbarn
draw title DU conc [ug m-3] and U [m s-1]

set gxout contour
set clevs -12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12
d u

plotpng slice.bF_F25b9-base-v1.png
