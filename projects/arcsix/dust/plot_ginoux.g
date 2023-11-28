sdfopen /home/colarco/sandbox/Emissions/Dust/input/dust_source_0.25x0.25.nc
set lon -180 180
set gxout grfill
set mpdset hires
set grads off
set clevs 0 .1 .2 .3 .4 .5 .6 .7 .8 .9
d source
cbarn
draw title Raw 0.25x0.25 topo source
printim dust_source_0.25x0.25.png white

reinit
xdfopen gao.ddf
set lon -180 180
set gxout grfill
set mpdset hires
set grads off
set clevs 0 .1 .2 .3 .4 .5 .6 .7 .8 .9
d source
cbarn
draw title Raw 1x1.25 GAO source
printim gao.png white
