xdfopen d5124_m2_jan79.ddf

set gxout shaded
set mpdset hires
set grads off

set lon -130 -60
set lat 26 50

set time 12z15jul2020
var = dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass
varm = ave(dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass,t=283,t=513,12)
set clevs -20 -10 -5 -2 -1 1 2 5 10 20
d (var-varm)*1e9
draw title July 2020
cbarn
printim napm25_anom.merra2.202007.png white


c
set time 12z15aug2020
var = dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass
varm = ave(dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass,t=283,t=513,12)
set clevs -20 -10 -5 -2 -1 1 2 5 10 20
d (var-varm)*1e9
draw title August 2020
cbarn
printim napm25_anom.merra2.202008.png white


c
set time 12z15sep2020
var = dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass
varm = ave(dusmass25+sssmass25+ocsmass+bcsmass+132./96.*so4smass,t=283,t=513,12)
set clevs -20 -10 -5 -2 -1 1 2 5 10 20
d (var-varm)*1e9
draw title September 2020
cbarn
printim napm25_anom.merra2.202009.png white
