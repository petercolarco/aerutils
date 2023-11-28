sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.3
cbarn
printim c180ctm_I32p9_NRLmrdamon.png white



reinit
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.3
cbarn
printim c180ctm_I32p9_M2mrdamon.png white





reinit
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.3
cbarn
printim Replay-M2.png white





reinit
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.2
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1
d totexttau.3
cbarn
printim ReplayNRL.png white



