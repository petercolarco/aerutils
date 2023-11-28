* v1 optics
sdfopen v1_5/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2016m0921t221551.vl_rad.geos5_pressure.ext.grid.nc4

c
set grads off
set gxout shaded
set lon -30 30
set lat -40 30
set clevs -2 -1.5 -1 -.5 0 .5 1 1.5 2 2.5 3 3.5
d ai
cbarn
draw title MERRA2 v1
plotpng ai.v1.v1731.png

reinit
* v5 optics
sdfopen v5_5/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2016m0921t221551.vl_rad.geos5_pressure.ext.grid.nc4

c
set grads off
set gxout shaded
set lon -30 30
set lat -40 30
set clevs -2 -1.5 -1 -.5 0 .5 1 1.5 2 2.5 3 3.5
d ai
cbarn
draw title MERRA2 v5
plotpng ai.v5.v1731.png



reinit
* v7 optics
sdfopen v7_5/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2016m0921t221551.vl_rad.geos5_pressure.ext.grid.nc4

c
set grads off
set gxout shaded
set lon -30 30
set lat -40 30
set clevs -2 -1.5 -1 -.5 0 .5 1 1.5 2 2.5 3 3.5
d ai
cbarn
draw title MERRA2 v7
plotpng ai.v7.v1731.png


reinit
* OMI
sdfopen /misc/prc08/colarco/OMAERUV_V1731_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2016m0921t221551.grid.nc4 

c
set grads off
set gxout shaded
set lon -30 30
set lat -40 30
set clevs -2 -1.5 -1 -.5 0 .5 1 1.5 2 2.5 3 3.5
d ai
cbarn
draw title OMI AI
plotpng ai.omi.v1731.png

