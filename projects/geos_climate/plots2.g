sdfopen S2S1850nrst.last10.nc
sdfopen S2S1850CO2x4pl.last10.nc
sdfopen CO2x4sensSS.nc

set gxout shaded
set lon -180 180
ssem1 = (ssem001+ssem002+ssem003+ssem004+ssem005)*365*86400
ssem2 = (ssem001.2+ssem002.2+ssem003.2+ssem004.2+ssem005.2)*365*86400
ssem3 = (ssem001.3(t=1)+ssem002.3(t=1)+ssem003.3(t=1)+ssem004.3(t=1)+ssem005.3(t=1))*365*86400
xycomp ssem2 ssem1
printim ssem.v4xCO2.png white

c
xycomp ssem3 ssem1
printim ssem.vsensSS.png white
