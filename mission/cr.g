reinit
clear
set date = 2005062100
xdfopen sfc.$date.ddf

set lon -120 -30
set lat -10 40
set gxout shaded

***********************************************
* AOT
clear
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
d duexttau
draw title Dust AOT $date
cbarn
printim aot.du.$date.png


clear
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d duexttau+ssexttau+suexttau+ocexttau+bcexttau
draw title Total AOT $date
cbarn
printim aot.total.$date.png


clear
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
d ocexttau+bcexttau
draw title Carbonaceous AOT $date
cbarn
printim aot.cc.$date.png



clear
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
d suexttau
draw title Sulfate AOT $date
cbarn
printim aot.su.$date.png

***********************************************
* PRS - surfaces
reinit
xdfopen prs.$date.ddf

clear
set gxout shaded
set lon -120 -30
set lat -10 40

set lev 500
d co
draw title CO 500 mbar [ppmb]
cbarn
printim co.500.$date.png
