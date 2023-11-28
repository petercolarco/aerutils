xdfopen ocean.ddf
xdfopen land.ddf
xdfopen deep.ddf
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(tau_,t=1,t=240)
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(tau_.2,t=1,t=240)
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(tau_.3,t=1,t=240)
cbarn
printim MYD04.png white
