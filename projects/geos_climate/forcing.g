sdfopen S2Sclim1850.geosgcm_rad.clim.YYYYann.c.nc
sdfopen bench_i329_gmi_free_c180.tavg24_2d_dad_Nx.monthly.clim.ANN.c.nc

set gxout shaded

aa = olrc - olrcna

bb = lwtupclr.2(t=1) - lwtupclrcln.2(t=1)

xycomp aa bb
printim olrcna.png white


c
xycomp olr lwtup.2(t=1)
printim olr.png white


c
aa = swtnet - swtnetna
bb = swtnt.2(t=1) - swtntcln.2(t=1)
xycomp aa bb
printim swtntna.png white
