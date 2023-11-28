set dd  = 24

xdfopen v3.tavg3d_aer_p.ddf
xdfopen v4.tavg3d_aer_p.ddf

while ( $dd < 31)

set t $dd
c
set lat 30 90
set lev 1000 20
set zlog on
set gxout shaded
set lon 180
set clevs -90 -60 -30 -10 -3 3 10 30 60 90
d (so2*airdens-so2.2*airdens.2)*1e9
cbarn
printim so2.201906${dd}.180.png white

c
set lat 30 90
set lev 1000 20
set zlog on
set gxout shaded
set lon 150
set clevs -90 -60 -30 -10 -3 3 10 30 60 90
d (so2*airdens-so2.2*airdens.2)*1e9
cbarn
printim so2.201906${dd}.150.png white

c
set lat 30 90
set lev 1000 20
set zlog on
set gxout shaded
set lon -150
set clevs -90 -60 -30 -10 -3 3 10 30 60 90
d (so2*airdens-so2.2*airdens.2)*1e9
cbarn
printim so2.201906${dd}.210.png white


@ dd = $dd + 1

end
