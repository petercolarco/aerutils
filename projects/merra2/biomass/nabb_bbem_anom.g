xdfopen d5124_m2_jan79.ddf

set gxout shaded
set mpdset hires
set grads off

set lon -130 -60
set lat 26 50

set time 12z15jul2022
bb = ave(bcembb,t=283,t=513,12)
set clevs -0.05 -0.02 -0.01 -0.005 -0.002 -0.001 .001 .002 .005 .01 .02 .05
d (bcembb-bb)*1000*30*86400
draw title July 2022
cbarn
printim nabb_bbem_anom.merra2.202207.png white


c
set time 12z15aug2022
bb = ave(bcembb,t=284,t=514,12)
set clevs -0.05 -0.02 -0.01 -0.005 -0.002 -0.001 .001 .002 .005 .01 .02 .05
d (bcembb-bb)*1000*30*86400
draw title August 2022
cbarn
printim nabb_bbem_anom.merra2.202208.png white

c
set time 12z15sep2022
bb = ave(bcembb,t=283,t=513,12)
set clevs -0.05 -0.02 -0.01 -0.005 -0.002 -0.001 .001 .002 .005 .01 .02 .05
d (bcembb-bb)*1000*30*86400
draw title September 2022
cbarn
printim nabb_bbem_anom.merra2.202209.png white
