sdfopen /misc/prc14/colarco/bF_F25b9-base-v7/tavg2d_carma_x/bF_F25b9-base-v7.tavg2d_carma_x.monthly.clim.JJA.nc4
sdfopen /misc/prc14/colarco/bF_F25b9-base-v5/tavg2d_carma_x/bF_F25b9-base-v5.tavg2d_carma_x.monthly.clim.JJA.nc4

set lon -90 0
set lat 0 45
set gxout shaded
set mpdset hires

xycomp ducmass*1e6 ducmass.2*1e6
draw string 1 10.9 Fv7
draw string 1 7.3 Fv5
