xdfopen MISR.d.monthly.ctl
xdfopen ../ctl/c180R_G40b11.tavg2d_aer_x.ctl

set z 3

set t 1 120
set x 1
set y 1

tau = aave(aodtau,lon=-180,lon=180,lat=-60,lat=60)
taul = aave(maskout(aodtau,lwi.2(t=1)-1),lon=-180,lon=180,lat=-60,lat=60)
tauo = aave(maskout(aodtau,1-lwi.2(t=1)),lon=-180,lon=180,lat=-60,lat=60)


d tau
d taul
t tauo

