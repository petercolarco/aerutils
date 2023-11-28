xdfopen c180F_v202_hungatonga_r0f0.ddf
set t 1 8
set x 1
set y 1
set vrange 0 0.25
so4 = aave(so4cmass,lon=-180,lon=180,lat=-30,lat=0)
so2 = aave(so2cmass,lon=-180,lon=180,lat=-30,lat=0)
d so2*1.3e14*1000/1e12/2.
d so4*1.3e14*1000/1e12/3.
printim su.r0f0.png white


reinit
xdfopen g5gmao.ddf
set t 1 8
set x 1
set y 1
set vrange 0 0.25
so4 = aave(so4cmass,lon=-180,lon=180,lat=-30,lat=0)
so2 = aave(so2cmass,lon=-180,lon=180,lat=-30,lat=0)
d so2*1.3e14*1000/1e12/2.
d so4*1.3e14*1000/1e12/3.
printim su.g5gmao.png white
