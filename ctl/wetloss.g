xdfopen bR_Fortuna-2_5-b7.tavg2d_aer_x.ctl
xdfopen b_F25b7-base-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b7-base-v1.tavg2d_carma_x.ctl
xdfopen bF_F25b7-base-v5.tavg2d_carma_x.ctl
xdfopen bF_F25b7-base-v6.tavg2d_carma_x.ctl
xdfopen bF_F25b7-base-v7.tavg2d_carma_x.ctl

set t 6
set lon -80 0
set vrange 0 1
set cthick 12
wloss = (duwt001+duwt002+duwt003+duwt004+duwt005+dusv001+dusv002+dusv003+dusv004+dusv005)
tloss = (dusd001+dusd002+dusd003+dusd004+dusd005+dudp001+dudp002+dudp003+dudp004+dudp005)
tloss = tloss + wloss
d ave(wloss*1e12/(tloss*1e12),lat=10,lat=20)
set ccolor 3
set dfile 2
d ave((duwt+dusv)*1e12/((duwt+dusv+dusd+dudp)*1e12),lat=10,lat=20)
set ccolor 2
set dfile 3
d ave((duwt+dusv)*1e12/((duwt+dusv+dusd+dudp)*1e12),lat=10,lat=20)
set ccolor 7
set dfile 4
d ave((duwt+dusv)*1e12/((duwt+dusv+dusd+dudp)*1e12),lat=10,lat=20)
set ccolor 9
set dfile 5
d ave((duwt+dusv)*1e12/((duwt+dusv+dusd+dudp)*1e12),lat=10,lat=20)
set ccolor 11
set dfile 6
d ave((duwt+dusv)*1e12/((duwt+dusv+dusd+dudp)*1e12),lat=10,lat=20)
draw title June 2003 Wet Loss Fraction of Total Loss 10 - 20 N
plotpng wetloss.png
