sdfopen /misc/prc14/colarco/c48R_H54p1-acma/tavg3d_aer_p/c48R_H54p1-acma.tavg3d_aer_p.monthly.clim.ANN.nc4
sdfopen /misc/prc14/colarco/c48R_H54p1v3-acma/tavg3d_aer_p/c48R_H54p1v3-acma.tavg3d_aer_p.monthly.clim.ANN.nc4

c
set x 1
set lev 1000 50
set gxout shaded
set zlog on
d ave(oc.1,x=1,x=144)*1e9
cbarn
plotpng ocppbm.baseline.png

c
set x 1
set lev 1000 50
set gxout shaded
set zlog on
d ave(oc.2,x=1,x=144)*1e9
cbarn
plotpng ocppbm.voc.png

c
set x 1
set lev 1000 50
set gxout shaded
set zlog on
d ave(oc.2-oc.1,x=1,x=144)*1e9
cbarn
plotpng ocppbm_diff.voc-baseline.png
