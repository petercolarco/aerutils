reinit
xdfopen S2S1850CO2x4pl.ddf
set x 1
set y 1
set t 1 252
set vrange 0 150
ss = aave(sscmass,lon=-180,lon=-170,lat=-25,lat=-15)
d ss*1e6
xdfopen S2S1850CO2x4pl.surf.ddf
uu = aave(u10m.2*u10m.2+v10m.2*v10m.2,lon=-180,lon=-170,lat=-25,lat=-15)
d uu
printim time.png white

d tcorr(ss,uu,t=1,t=12)
