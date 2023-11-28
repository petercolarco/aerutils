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
d duexttau-duexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d duexttau.2-duexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d duexttau.3-duexttau.6
printim ctmdiff.du.png white


reinit
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
d suexttau-suexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d suexttau.2-suexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d suexttau.3-suexttau.6
printim ctmdiff.su.png white



reinit
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
d ocexttau-ocexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d ocexttau.2-ocexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d ocexttau.3-ocexttau.6
printim ctmdiff.oc.png white


reinit
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
d ssexttau-ssexttau.4
cbarn
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d ssexttau.2-ssexttau.5
set clevs -.2 -.1 -.05 -.01 .01 .05  .1 .2 
d ssexttau.3-ssexttau.6
printim ctmdiff.ss.png white
