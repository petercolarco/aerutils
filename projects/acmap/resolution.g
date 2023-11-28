sdfopen /misc/prc14/colarco/c48R_H53-acma/inst2d_hwl_x/Y2008/M07/c48R_H53-acma.inst2d_hwl_x.20080731_0000z.nc4
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2
d totexttau
cbarn
plotpng c48R.png

reinit
sdfopen /misc/prc14/colarco/c90R_H53-acma/inst2d_hwl_x/Y2008/M07/c90R_H53-acma.inst2d_hwl_x.20080731_0000z.nc4
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2
d totexttau
cbarn
plotpng c90R.png

reinit
sdfopen /misc/prc14/colarco/c180R_H53-acma/inst2d_hwl_x/Y2008/M07/c180R_H53-acma.inst2d_hwl_x.20080731_0000z.nc4
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2
d totexttau
cbarn
plotpng c180R.png

reinit
sdfopen /misc/prc14/colarco/c360R_H53-acma/inst2d_hwl_x/Y2008/M07/c360R_H53-acma.inst2d_hwl_x.20080731_0000z.nc4
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2
d totexttau
cbarn
plotpng c360R.png

reinit
sdfopen /misc/prc14/colarco/c720R_H53-acma/inst2d_hwl_x/Y2008/M07/c720R_H53-acma.inst2d_hwl_x.20080731_0000z.nc4
set grads off
set lon -60 300
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2
d totexttau
cbarn
plotpng c720R.png


