reinit
sdfopen /home/colarco/projects/MAP16_BB/old/clm4.5_closs.nc
set t 1 444
set x 1
set y 1
* Tg month from gC/m2/s
emis = aave(closs,g)*86400*30./1e15*5.1e14
d emis
draw title Monthly Carbon Emission from Fires [Pg]
printim closs_monthly.png white


reinit
sdfopen /home/colarco/projects/MAP16_BB/old/clm4.5_closs.nc
set lon -180 180
set t 1
* 1997 - 2016 total gC/m2/yr
cltot = sum(closs,t=205,t=444)*30*86400/20.
set clevs 0 5 10 20 50 100 200 500 1000
set gxout shaded
d cltot
draw title CLM4.5 annual average carbon loss gC/m2/yr
cbarn
printim closs_tot.png white


reinit
sdfopen /home/colarco/projects/MAP16_BB/old/clm4.5_closs.nc
set lon -180 180
set t 1
* 1997 - 2016 total gC/m2/yr
cltot = sum(closs,t=205,t=444)*30*86400/20.
* give a stupid emission factor of 5 g/kg * 1.8 OM/DM
omem  = 
set clevs 0 5 10 20 50 100 200 500 1000
set gxout shaded
d cltot
draw title CLM4.5 annual average carbon loss gC/m2/yr
cbarn
printim closs_tot.png white
