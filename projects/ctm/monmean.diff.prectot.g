sdfopen /misc/prc18/colarco/ReplayNRL/ReplayNRL.tavg1_2d_flx_Nx.monthly.201804.nc4
sdfopen /misc/prc18/colarco/Replay-M2/Replay-M2.tavg1_2d_flx_Nx.monthly.201804.nc4
set grads off
set lon -180 180
set gxout grfill
set clevs -10 -5 -2 -1 1 2 5 10
d prectot*86400-prectot.2*86400
cbarn
printim replaydiff.prectot.png white

* mm day-1
