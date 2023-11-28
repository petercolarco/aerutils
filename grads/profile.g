sdfopen /misc/prc11/colarco/b_Fortuna-2_5-b2/tavg3d_aer_p/Y2007/M06/b_Fortuna-2_5-b2.tavg3d_aer_p.monthly.200706.nc4
sdfopen /misc/prc11/colarco/b_F25b2-noconv/tavg3d_aer_p/Y2007/M06/b_F25b2-noconv.tavg3d_aer_p.monthly.200706.nc4
sdfopen /misc/prc11/colarco/b_F25b2-noheat/tavg3d_aer_p/Y2007/M06/b_F25b2-noheat.tavg3d_aer_p.monthly.200706.nc4
sdfopen /misc/prc11/colarco/b_F25b2-emlast/tavg3d_aer_p/Y2007/M06/b_F25b2-emlast.tavg3d_aer_p.monthly.200706.nc4

set gxout shaded
set x 1
set lev 1000 50
set zlog on
xzcomp ave(bc.1,x=1,x=144)*1e12 ave(bc.2,x=1,x=144)*1e12
plotpng bcnoconv.png

set gxout shaded
set x 1
set lev 1000 50
set zlog on
xzcomp ave(bc.1,x=1,x=144)*1e12 ave(bc.3,x=1,x=144)*1e12
plotpng bcnoheat.png

set gxout shaded
set x 1
set lev 1000 50
set zlog on
xzcomp ave(bc.1,x=1,x=144)*1e12 ave(bc.4,x=1,x=144)*1e12
plotpng bcemlast.png

