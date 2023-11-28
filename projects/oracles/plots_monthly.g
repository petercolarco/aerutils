sdfopen /misc/prc18/colarco/c180R_pI33p7/inst2d_hwl_x/Y2016/M08/c180R_pI33p7.inst2d_hwl_x.MYD04_L2_ocn.aero_tc8_006.qast.201608.nc4
sdfopen /misc/prc18/colarco/c180R_pI33p7/inst2d_hwl_x/Y2016/M08/c180R_pI33p7.inst2d_hwl_x.MYD04_L2_lnd.aero_tc8_006.qast3.201608.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
draw title GEOS
printim c180R_pI33p7.inst2d_hwl_x.MYD04_L2_lnd.aero_tc8_006.201608.png white

reinit
sdfopen /misc/prc18/colarco/c180R_pI33p7/inst2d_hwl_x/Y2016/M09/c180R_pI33p7.inst2d_hwl_x.MYD04_L2_ocn.aero_tc8_006.qast.201609.nc4
sdfopen /misc/prc18/colarco/c180R_pI33p7/inst2d_hwl_x/Y2016/M09/c180R_pI33p7.inst2d_hwl_x.MYD04_L2_lnd.aero_tc8_006.qast3.201609.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
draw title GEOS
printim c180R_pI33p7.inst2d_hwl_x.MYD04_L2_lnd.aero_tc8_006.201609.png white

reinit
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2016/M08/MYD04_L2_ocn.aero_tc8_006.qast_qawt.201608.nc4
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2016/M08/MYD04_L2_lnd.aero_tc8_006.qast3_qawt.201608.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d aot.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d aot
cbarn
draw title MYD04
printim MYD04_L2_lnd.aero_tc8_006_qawt.201608.png white

reinit
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2016/M09/MYD04_L2_ocn.aero_tc8_006.qast_qawt.201609.nc4
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2016/M09/MYD04_L2_lnd.aero_tc8_006.qast3_qawt.201609.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d aot.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d aot
cbarn
draw title MYD04
printim MYD04_L2_lnd.aero_tc8_006_qawt.201609.png white
