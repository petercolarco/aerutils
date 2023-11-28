reinit
clear
set date = 2005062100
set valid = 18z21jun2005
xdfopen sfc.$date.ddf

set lon -120 -60
set lat -20 30
set gxout shaded

***********************************************
* PREACC
clear
set time $valid
d preacc
draw title preacc [mm/day] ${date}_valid_$valid
cbarn
printim preacc.$date.$valid.png


* COEM001
clear
set time $valid
d coem001
draw title co emissions [kg m-2 s-1] ${date}_valid_$valid
cbarn
printim coem001.$date.$valid.png
