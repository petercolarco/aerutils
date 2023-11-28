xdfopen bR_Fortuna-2_5-b7.tavg2d_aer_x.ctl
xdfopen b_F25b7-base-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v5.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v6.tavg2d_carma_x.ctl
xdfopen bF_F25b8-chem-v7.tavg2d_carma_x.ctl

set t 6
set lon -22
set lat 16
scale1 = ave(duexttau.1,lat=10,lat=20)
scale2 = ave(duexttau.2,lat=10,lat=20)
scale3 = ave(duexttau.3,lat=10,lat=20)
scale4 = ave(duexttau.4,lat=10,lat=20)
scale5 = ave(duexttau.5,lat=10,lat=20)
scale6 = ave(duexttau.6,lat=10,lat=20)
scale = duexttau
set lon -80 0
set vrange 0 2
set cthick 12
d ave(duexttau.1,lat=10,lat=20)/scale1
set ccolor 3
d ave(duexttau.2,lat=10,lat=20)/scale2
set ccolor 2
d ave(duexttau.3,lat=10,lat=20)/scale3
set ccolor 7
d ave(duexttau.4,lat=10,lat=20)/scale4
set ccolor 9
d ave(duexttau.5,lat=10,lat=20)/scale5
set ccolor 11
d ave(duexttau.6,lat=10,lat=20)/scale6
draw title June 2003 DUEXTTAU 10 - 20 N
plotpng gradient.png
