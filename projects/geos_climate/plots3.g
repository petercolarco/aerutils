sdfopen S2S1850nrst.last10.nc
sdfopen S2S1850CO2x4pl.last10.nc
sdfopen CO2x4sensSS.nc

set gxout shaded
set lon -180 180
niht1 = (niht001+niht002+niht003)*365*86400
niht2 = (niht001.2+niht002.2+niht003.2)*365*86400
niht3 = (niht001.3(t=1)+niht002.3(t=1)+niht003.3(t=1))*365*86400
xycomp niht2 niht1
printim niht.v4xCO2.png white

c
xycomp niht3 niht1
printim niht.vsensSS.png white
