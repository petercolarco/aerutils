sdfopen /misc/prc14/colarco/c48R_H53-acma/geosgcm_surf/c48R_H53-acma.geosgcm_surf.monthly.200809.nc4
set grads off
set lon -30 40
set lat -50 10
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7  
d cldlo
cbarn
plotpng c48R.png

reinit
sdfopen /misc/prc14/colarco/c90R_H53-acma/geosgcm_surf/c90R_H53-acma.geosgcm_surf.monthly.200809.nc4
set grads off
set lon -30 40
set lat -50 10
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7  
d cldlo
cbarn
plotpng c90R.png

reinit
sdfopen /misc/prc14/colarco/c180R_H53-acma/geosgcm_surf/c180R_H53-acma.geosgcm_surf.monthly.200809.nc4
set grads off
set lon -30 40
set lat -50 10
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7  
d cldlo
cbarn
plotpng c180R.png

reinit
sdfopen /misc/prc14/colarco/c360R_H53-acma/geosgcm_surf/c360R_H53-acma.geosgcm_surf.monthly.200809.nc4
set grads off
set lon -30 40
set lat -50 10
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7  
d cldlo
cbarn
plotpng c360R.png
