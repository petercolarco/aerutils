xdfopen d5124_m2_jan79.ddf

set gxout shaded
set mpdset hires
set grads off

set lon -130 -60
set lat 26 50

set time 12z15jul2022
set clevs .001 .002 .005 .01 .02 .05 .1 .2 .4 .6
d bcembb*1000*30*86400
draw title July 2022
cbarn
printim nabb_bbem.merra2.202207.png white

c
set time 12z15aug2022
set clevs .001 .002 .005 .01 .02 .05 .1 .2 .4 .6
d bcembb*1000*30*86400
draw title August 2022
cbarn
printim nabb_bbem.merra2.202208.png white

c
set time 12z15sep2022
set clevs .001 .002 .005 .01 .02 .05 .1 .2 .4 .6
d bcembb*1000*30*86400
draw title September 2022
cbarn
printim nabb_bbem.merra2.202209.png white
