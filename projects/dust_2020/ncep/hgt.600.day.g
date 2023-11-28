sdfopen hgt.2020.nc
sdfopen hgt.clim.mean.jun.nc

set gxout shaded
set lon -60 60
set lat -10 60
set lev 600

set i = 153

while ( $i < 183)
c
set t $i
xycomp hgt hgt.2(t=1)
draw title $i
printim hgt.600.$i.png white

@ i = $i + 1
end
