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
d (swtnetna-swtnetna.3(t=1))
cbarn
draw title diff SWTNETNA strong dust - no dust
plotpng swtnetna.strongdust.png

c
d (swtnetna.2-swtnetna.3(t=1))
cbarn
draw title diff SWTNETNA weak dust - no dust
plotpng swtnetna.weakdust.png
