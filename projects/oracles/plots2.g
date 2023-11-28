sdfopen /misc/prc18/colarco/c180R_I33_SChem_TQvblend_SE_newoptics/inst2d_hwl_x/c180R_I33_SChem_TQvblend_SE_newoptics.inst2d_hwl_x.20170813_1200z.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
draw title GEOS
printim c180R_I33_SChem_TQvblend_SE_newoptics.inst2d_hwl_x.20170813.png white

reinit
sdfopen /misc/prc18/colarco/c180R_I33_SChem_TQvblend_SE_newoptics/inst2d_hwl_x/c180R_I33_SChem_TQvblend_SE_newoptics.inst2d_hwl_x.20170817_1200z.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
draw title GEOS
printim c180R_I33_SChem_TQvblend_SE_newoptics.inst2d_hwl_x.20170817.png white

reinit
sdfopen /misc/prc18/colarco/c180R_I33_SChem_TQvblend_SE_newoptics/inst2d_hwl_x/c180R_I33_SChem_TQvblend_SE_newoptics.inst2d_hwl_x.20170818_1200z.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
cbarn
draw title GEOS
printim c180R_I33_SChem_TQvblend_SE_newoptics.inst2d_hwl_x.20170818.png white

reinit
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2017/M08/MYD04_L2_ocn.aero_tc8_006.qast.20170813.nc4
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2017/M08/MYD04_L2_lnd.aero_tc8_006.qast3.20170813.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(aot.2,t=1,t=24)
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(aot,t=1,t=24)
cbarn
draw title MYD04
printim MYD04_L2_lnd.aero_tc8_006.20170813.png white

reinit
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2017/M08/MYD04_L2_ocn.aero_tc8_006.qast.20170818.nc4
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2017/M08/MYD04_L2_lnd.aero_tc8_006.qast3.20170818.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(aot.2,t=1,t=24)
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(aot,t=1,t=24)
cbarn
draw title MYD04
printim MYD04_L2_lnd.aero_tc8_006.20170818.png white

reinit
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2017/M08/MYD04_L2_ocn.aero_tc8_006.qast.20170817.nc4
sdfopen /science/modis/data/Level3/MYD04/hourly/d/GRITAS/Y2017/M08/MYD04_L2_lnd.aero_tc8_006.qast3.20170817.nc4
set gxout grfill
set lon -40 40
set lat -50 15
set grads off
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(aot.2,t=1,t=24)
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d ave(aot,t=1,t=24)
cbarn
draw title MYD04
printim MYD04_L2_lnd.aero_tc8_006.20170817.png white
