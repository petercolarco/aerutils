sdfopen /misc/prc14/colarco/c48R_H53-acma/geosgcm_prog/c48R_H53-acma.geosgcm_prog.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs -100 -80 -60 -40 -20 0 20 40
d ave(omega*86400/100,lat=-15,lat=0)
cbarn
plotpng c48R.png

reinit
sdfopen /misc/prc14/colarco/c90R_H53-acma/geosgcm_prog/c90R_H53-acma.geosgcm_prog.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs -100 -80 -60 -40 -20 0 20 40
d ave(omega*86400/100,lat=-15,lat=0)
cbarn
plotpng c90R.png

reinit
sdfopen /misc/prc14/colarco/c180R_H53-acma/geosgcm_prog/c180R_H53-acma.geosgcm_prog.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs -100 -80 -60 -40 -20 0 20 40
d ave(omega*86400/100,lat=-15,lat=0)
cbarn
plotpng c180R.png

reinit
sdfopen /misc/prc14/colarco/c360R_H53-acma/geosgcm_prog/c360R_H53-acma.geosgcm_prog.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs -100 -80 -60 -40 -20 0 20 40
d ave(omega*86400/100,lat=-15,lat=0)
cbarn
plotpng c360R.png
