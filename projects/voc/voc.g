xdfopen ../../ctl/c48R_H54p1-acma.tavg2d_aer_x.ctl
xdfopen ../../ctl/c48R_H54p1v3-acma.tavg2d_aer_x.ctl

set x 1
set y 1
set t 1 12
oc1 = aave(ocexttau,g)
oc2 = aave(ocexttau.2,g)

set grads off
set vrange 0 0.05
d oc2
d oc1
plotpng ocexttau.png

c
d oc2-oc1
plotpng ocexttau_diff.png

c
oc1 = aave(ocem001+ocem002,g)*86400*30*5.1e5
oc2 = aave(ocem001.2+ocem002.2,g)*86400*30*5.1e5
set vrange 0 20
d oc2
d oc1
plotpng ocem.png

c
d oc2-oc1
plotpng ocem_diff.png

reinit
sdfopen /misc/prc14/colarco/c48R_H54p1-acma/tavg2d_aer_x/c48R_H54p1-acma.tavg2d_aer_x.monthly.clim.ANN.nc4
sdfopen /misc/prc14/colarco/c48R_H54p1v3-acma/tavg2d_aer_x/c48R_H54p1v3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4

c
set gxout shaded
set lon -180 180
set lat -90 90
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
d ocexttau.2
cbarn
plotpng ocexttau.voc.png

c
set gxout shaded
set lon -180 180
set lat -90 90
set clevs .05 .1 .15 .2 .25 .3 .35 .4 .45 .5
d ocexttau.1
cbarn
plotpng ocexttau.baseline.png

c
set gxout shaded
set lon -180 180
set lat -90 90
d ocexttau.2-ocexttau.1
cbarn
plotpng ocexttau_diff.voc-base.png

c
set gxout shaded
set lon -180 180
set lat -90 90
set clevs 1 2 5 10 15 20 25 30 35 40
d ocsmass*1e9
cbarn
plotpng ocsmass.baseline.png

c
set gxout shaded
set lon -180 180
set lat -90 90
set clevs 1 2 5 10 15 20 25 30 35 40
d ocsmass.2*1e9
cbarn
plotpng ocsmass.voc.png

c
set gxout shaded
set lon -180 180
set lat -90 90
set clevs .1 .2 .5 1 2 5 8 12
d (ocsmass.2-ocsmass)*1e9
cbarn
plotpng ocsmass_diff.voc-baseline.png

