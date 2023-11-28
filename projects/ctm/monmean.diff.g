sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau-totexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau.2-totexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau.3-totexttau.6
printim ctmdiff.png white



reinit
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau-totexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau.2-totexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau.3-totexttau.6
printim replay.png white



reinit
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.ocean.201804.nc4
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.land.201804.nc4
sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.inst2d_hwl_x.nnr_003.MYD04_L3a.deep.201804.nc4 
set grads off
set lon -180 180
set gxout grfill
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau-totexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau.2-totexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d totexttau.3-totexttau.6
printim ctm-replay.NRL.diff.png white
