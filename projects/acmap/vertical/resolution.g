sdfopen /misc/prc14/colarco/c48R_H53-acma/tavg3d_aerdiag_v/c48R_H53-acma.tavg3d_aerdiag_v.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs .04 .08 .12 .16 .2 .24  
d ocextcoef*1000
cbarn
plotpng c48R.png

reinit
sdfopen /misc/prc14/colarco/c90R_H53-acma/tavg3d_aerdiag_v_c/c90R_H53-acma.tavg3d_aerdiag_v_c.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs .04 .08 .12 .16 .2 .24  
d ocextcoef*1000
cbarn
plotpng c90R.png

reinit
sdfopen /misc/prc14/colarco/c180R_H53-acma/tavg3d_aerdiag_v_c/c180R_H53-acma.tavg3d_aerdiag_v_c.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs .04 .08 .12 .16 .2 .24  
d ocextcoef*1000
cbarn
plotpng c180R.png

reinit
sdfopen /misc/prc14/colarco/c360R_H53-acma/tavg3d_aerdiag_v_c/c360R_H53-acma.tavg3d_aerdiag_v_c.monthly.200809.nc4
set grads off
set lon -30 40
set lat -6
set z 1 20
set gxout shaded
set clevs .04 .08 .12 .16 .2 .24  
d ocextcoef*1000
cbarn
plotpng c360R.png
