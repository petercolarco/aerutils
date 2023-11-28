sdfopen uwnd.mon.mean.jun.nc

set lon -60 60
set lat -10 60
set gxout shaded

set lev 925

du = ave(uwnd,t=1,t=41)
d sqrt(ave(pow(du-uwnd,2),t=1,t=41))
cbarn

printim uwnd925.std.png white
