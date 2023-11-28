xdfopen dR_F25b18.geosgcm_surf.ctl
xdfopen c180R_G40b11.geosgcm_surf.ctl

set x 1
set y 1
set t 1 12

dr = aave(cldlo,lon=80,lon=125,lat=10,lat=40)
c180 = aave(cldlo.2,lon=80,lon=125,lat=10,lat=40)

num = (c180-dr)*1e12
den = c180*1e12

d num/den
plotpng cldlo.png

c
dr = aave(cldmd,lon=80,lon=125,lat=10,lat=40)
c180 = aave(cldmd.2,lon=80,lon=125,lat=10,lat=40)

num = (c180-dr)*1e12
den = c180*1e12

d num/den
plotpng cldmd.png

c
dr = aave(cldhi,lon=80,lon=125,lat=10,lat=40)
c180 = aave(cldhi.2,lon=80,lon=125,lat=10,lat=40)

num = (c180-dr)*1e12
den = c180*1e12

d num/den
plotpng cldhi.png

