sdfopen hgt.mon.mean.jun.nc

set lon -60 60
set lat -10 60
set gxout shaded

set lev 700

xycomp hgt(t=41) ave(hgt,t=1,t=41)

printim hgt700.png white
