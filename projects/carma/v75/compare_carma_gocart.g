xdfopen c90F_pI33p9_volc.tavg2d_carma_x.ddf
xdfopen c90F_pI33p9_volc.tavg2d_aer_x.ddf

set x 1
set t 1 12

set gxout shaded

d ave(suexttau,lon=-180,lon=180)
