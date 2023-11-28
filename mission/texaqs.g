reinit
clear
sdfopen http://opendap.gsfc.nasa.gov:9090/dods/GEOS-4/aerochem/assim_met/chem_diag.sfc

set lon -120 -60
set lat 0 40
set gxout shaded


foreach dd (27 28 29 30 31)
 clear
 set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
 set time 12z${dd}Aug2006
 d duexttau
 cbarn
 draw title DUEXTTAU 12z${dd}Aug2006
 printim duaug${dd}.png

end


reinit
sdfopen http://opendap.gsfc.nasa.gov:9090/dods/GEOS-4/aerochem/assim_met/chem_diag.eta
clear
set lon -95.5
set lat 29.75
set lev 1000 100
set zlog on
set gxout shaded

set time 12z27Aug2006 12z31Aug2006
d dumass
cbarn
draw title DUMASS [mmr, kg/kg] at Houston
printim dummr.png


* off coast of Africa
clear
set time 12z28aug2006
set lon -20
set lat -10 40
d dumass
cbarn
draw title DUMASS [mmr, kg/kg] 12z28aug2006 at 20 W longitude
printim duafrica.png



clear
set lon -120 0
set lat -10 40
set lev 700
d dumass
cbarn
draw title DUMASS [mmr, kg/kg] 12z28aug2006 at 700 hPa alitutde
printim du700.png
