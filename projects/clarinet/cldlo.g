* opac mie
sdfopen /misc/prc14/colarco/bF_F25b9-base-v1/geosgcm_surf/bF_F25b9-base-v1.geosgcm_surf.monthly.clim.JJA.nc4

* obs mie
sdfopen /misc/prc14/colarco/bF_F25b9-base-v8/geosgcm_surf/bF_F25b9-base-v8.geosgcm_surf.monthly.clim.JJA.nc4

* no aerosol forcing
 sdfopen /misc/prc14/colarco/b_F25b9-base-v1/geosgcm_surf/b_F25b9-base-v1.geosgcm_surf.monthly.clim.JJA.nc4


set lon -100 0
set lat 0 30
set gxout shaded
set grads off
set clevs -8 -6 -4 -2 0 2 4 6 8 10
d (cldlo-cldlo.3(t=1))*100
cbarn
draw title diff %CLDLO strong dust - no dust
plotpng strongdust.png

c
set clevs -8 -6 -4 -2 0 2 4 6 8 10
d (cldlo.2-cldlo.3(t=1))*100
cbarn
draw title diff %CLDLO weak dust - no dust
plotpng weakdust.png

c
set clevs -8 -6 -4 -2 0 2 4 6 8 10
d (cldlo.1-cldlo.2)*100
cbarn
draw title diff %CLDLO strong dust - weak dust
plotpng strongweak.png

