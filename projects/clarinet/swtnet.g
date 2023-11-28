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
d (swtnet-swtnet.3(t=1))
cbarn
draw title diff SWTNET strong dust - no dust
plotpng swtnet.strongdust.png

c
d (swtnet.2-swtnet.3(t=1))
cbarn
draw title diff SWTNET weak dust - no dust
plotpng swtnet.weakdust.png
