sdfopen hgt.mon.mean.jun.nc

set lon -60 60
set lat -10 60
set gxout shaded

set lev 850

xycomp hgt(t=41) ave(hgt,t=1,t=41)

printim hgt850.png white
