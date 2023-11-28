sdfopen /misc/prc14/colarco/b_F25b9-base-v1/tavg3d_carma_p/b_F25b9-base-v1.tavg3d_carma_p.monthly.clim.JJA.nc4
sdfopen /misc/prc14/colarco/b_F25b9-base-v1/geosgcm_prog/b_F25b9-base-v1.geosgcm_prog.monthly.clim.JJA.nc4

set gxout shaded
set grads off
set lon -20
set lat -10 60
set lev 1000 500
set zlog on

set clevs 5 10 20 50 100 150 200 250 300 350 400
d du*1e9
cbarn

set gxout contour
set ccolor 0
set cthick 6
set clevs -15 -12 -9 -6 -3 0 3 6 9 12 15
d u.2(t=1)


plotpng b_F25b9-base-v1.profile_-20.png
