sdfopen hgt.mon.mean.jun.nc
sdfopen uwnd.mon.mean.jun.nc
sdfopen vwnd.mon.mean.jun.nc

set lon -60 60
set lat -10 60

set lev 500
set gxout shaded
dhgt = hgt(t=41)-ave(hgt,t=1,t=41)
d dhgt
cbarn

set gxout stream

d uwnd.2(t=41)-ave(uwnd.2,t=1,t=41) ; vwnd.3(t=41)-ave(vwnd.3,t=1,t=41)

printim stream500.png white
