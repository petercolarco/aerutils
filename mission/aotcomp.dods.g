reinit
sdfopen http://opendap.gsfc.nasa.gov:9090/dods/aero_obs/mod04_ocean.ddf
set lon -100 -40
set lat -10 30
set gxout shaded
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
set lev 550
set time 18z12jul2006
d tau
cbarn
draw title MOD04 20060712_18z aot [550 nm]
printim aot.mod04.200712_18z.png

reinit
sdfopen http://opendap.gsfc.nasa.gov:9090/dods/aero_obs/myd04_ocean.ddf
set lon -100 -40
set lat -10 30
set gxout shaded
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
set lev 550
set time 18z12jul2006
d tau
cbarn
draw title MYD04 20060712_18z aot [550 nm]
printim aot.myd04.200712_18z.png

reinit
sdfopen http://opendap.gsfc.nasa.gov:9090/dods/aero_obs/omi_ai.ddf
set lon -100 -40
set lat -10 30
set gxout shaded
set clevs 1 1.5 2 2.5 3 3.5 4 4.5
set z 2
set time 18z12jul2006
d ai
cbarn
draw title OMI 20060712_18z AI [354 nm]
printim ai.omi.200712_18z.png
