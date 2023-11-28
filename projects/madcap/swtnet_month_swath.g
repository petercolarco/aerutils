reinit
sdfopen c180R_pI33p7.full.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim full.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.full_day.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim full_day.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.full_day_cloud.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim full_day_cloud.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.calipso.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim calipso.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.calipso_day.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim calipso_day.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.calipso_day_cloud.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim calipso_day_cloud.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.calipso_swath.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim calipso_swath.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.calipso_swath_day.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim calipso_swath_day.swtnet.12z.png white

reinit
sdfopen c180R_pI33p7.calipso_swath_day_cloud.swtnet.monthly.201601.12z.nc
set lon -180 180
set gxout grfill
set grads off
set clevs -18 -15 -12 -9 -6 -3 0 3 6 9
d maskout(swtnet-swtnetna,swtnet-0.001)
cbarn
printim calipso_swath_day_cloud.swtnet.12z.png white

