sdfopen /misc/prc14/colarco/b_F25b9-base-v1/tavg3d_carma_p/b_F25b9-base-v1.tavg3d_carma_p.monthly.clim.JJA.nc4
sdfopen /misc/prc14/colarco/bF_F25b9-base-v7/tavg3d_carma_p/bF_F25b9-base-v7.tavg3d_carma_p.monthly.clim.JJA.nc4

set x 1
set lat 0 45
set lev 1000 500
set zlog on
set gxout shaded

du1 = ave(duconc,lon=-80,lon=-60)*1e9
du2 = ave(duconc.2,lon=-80,lon=-60)*1e9

yzcomp du1 du2
* draw string 1 10.9 Levoni (Mie)
* draw string 1 7.3 OPAC (Mie)

plotpng free.80_60.png
