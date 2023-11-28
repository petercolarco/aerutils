xdfopen d5124_m2_jan79.ddf

set gxout shaded
set mpdset hires
set grads off

set lon -130 -60
set lat 26 50

set time 12z15jul2021
var = dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass
set clevs 1 2 5 10 20 50 100 200
d var*1e9
draw title July 2021
cbarn
printim napm25_mean.merra2.202107.png white

c
set time 12z15aug2021
var = dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass
set clevs 1 2 5 10 20 50 100 200
d var*1e9
draw title August 2021
cbarn
printim napm25_mean.merra2.202108.png white

c
set time 12z15sep2021
var = dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass
set clevs 1 2 5 10 20 50 100 200
d var*1e9
draw title September 2021
cbarn
printim napm25_mean.merra2.202109.png white
