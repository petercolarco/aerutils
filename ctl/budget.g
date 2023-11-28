xdfopen dR_F25b18.tavg2d_aer_x.ctl
xdfopen c180R_G40b11.tavg2d_aer_x.ctl

set x 1
set y 1
set t 1 12

dr = aave(supso4g,lon=80,lon=125,lat=10,lat=40)
c180 = aave(supso4g.2,lon=80,lon=125,lat=10,lat=40)

num = (c180-dr)*1e12
den = c180*1e12

d num/den
plotpng supso4g.png

c
dr = aave(supso4aq,lon=80,lon=125,lat=10,lat=40)
c180 = aave(supso4aq.2,lon=80,lon=125,lat=10,lat=40)

num = (c180-dr)*1e12
den = c180*1e12

d num/den
plotpng supso4aq.png

c
dr = aave(supso4wt,lon=80,lon=125,lat=10,lat=40)
c180 = aave(supso4wt.2,lon=80,lon=125,lat=10,lat=40)

num = (c180-dr)*1e12
den = c180*1e12

d num/den
plotpng supso4wt.png

