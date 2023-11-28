xdfopen sfc.2006071312.ddf
set lon -100 -40
set lat -10 30
set gxout shaded
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
set time 18z14jul2006
d 0.5*duexttau+ssexttau+suexttau+ocexttau+bcexttau
cbarn
draw title GEOS-4 20060713_12z aot [550 nm]
printim aot.2006071312_2006071418.png
