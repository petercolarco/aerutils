sdfopen uwnd.mon.mean.jun.nc

set lon -60 60
set lat -10 60
set gxout shaded

set lev 925

xycomp uwnd(t=41) ave(uwnd,t=1,t=41)

printim uwnd925.png white