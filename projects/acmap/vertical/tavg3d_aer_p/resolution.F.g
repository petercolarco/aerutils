sdfopen /misc/prc14/colarco/c48F_H53-acma/tavg3d_aer_p/c48F_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c48F.png

reinit
sdfopen /misc/prc14/colarco/c90F_H53-acma/tavg3d_aer_p/c90F_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c90F.png

reinit
sdfopen /misc/prc14/colarco/c180F_H53-acma/tavg3d_aer_p/c180F_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c180F.png

reinit
sdfopen /misc/prc14/colarco/c360F_H53-acma/tavg3d_aer_p/c360F_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c360F.png
