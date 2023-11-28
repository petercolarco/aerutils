sdfopen S2Sclim1850.geosgcm_gocart2d.clim.YYYYann.c.nc
sdfopen bench_i329_gmi_free_c180.tavg1_2d_aer_Nx.monthly.clim.ANN.c.nc

set lon 0 360
set gxout shaded

set clevs .1 .2 .5 1 2 5 10 20 50
d ocembb*365*86400*1000
cbarn
printim ocembb.S2S.png white

c
set clevs .1 .2 .5 1 2 5 10 20 50
d ocembb.2(t=1)*365*86400*1000
cbarn
printim ocembb.bench.png white
