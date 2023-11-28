sdfopen hgt.mon.mean.jun.nc

set lon -60 60
set lat -10 60
set gxout shaded

set lev 700

du = ave(hgt,t=1,t=41)
d sqrt(ave(pow(du-hgt,2),t=1,t=41))
cbarn

printim hgt700.std.png white
