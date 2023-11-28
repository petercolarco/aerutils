sdfopen /misc/prc14/colarco/c48R_H53-acma/tavg3d_aer_p/c48R_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c48R.png

reinit
sdfopen /misc/prc14/colarco/c90R_H53-acma/tavg3d_aer_p/c90R_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c90R.png

reinit
sdfopen /misc/prc14/colarco/c180R_H53-acma/tavg3d_aer_p/c180R_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c180R.png

reinit
sdfopen /misc/prc14/colarco/c360R_H53-acma/tavg3d_aer_p/c360R_H53-acma.tavg3d_aer_p.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs 4 8 12 16 20 24  
d ave(oc*1e9,lat=-15,lat=0)
cbarn
plotpng c360R.png
