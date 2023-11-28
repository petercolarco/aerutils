sdfopen /misc/prc18/colarco/c180ctm_I32p9_NRLmrdamon/c180ctm_I32p9_NRLmrdamon.tavg2d_aer_x.monthly.201804.nc4
sdfopen /misc/prc18/colarco/c180ctm_I32p9_M2mrdamon/c180ctm_I32p9_M2mrdamon.tavg2d_aer_x.monthly.201804.nc4
set grads off
set lon -180 180
set gxout grfill
duem1 = (duem001+duem002+duem003+duem004+duem005)*30*86400*1000
duem2 = (duem001.2+duem002.2+duem003.2+duem004.2+duem005.2)*30*86400*1000
set clevs -10 -5 -2 -1 1 2 5 10
d duem1-duem2
cbarn
printim ctmdiff.duem.png white

* g m-2 mon-1


c
set grads off
set lon -180 180
set gxout grfill
duwt1 = (duwt001+duwt002+duwt003+duwt004+duwt005+dusv001+dusv002+dusv003+dusv004+dusv005)*30*86400*1000
duwt2 = (duwt001.2+duwt002.2+duwt003.2+duwt004.2+duwt005.2+dusv001.2+dusv002.2+dusv003.2+dusv004.2+dusv005.2)*30*86400*1000
set clevs -10 -5 -2 -1 1 2 5 10
d duwt1-duwt2
cbarn
printim ctmdiff.duwt.png white

c
set grads off
set lon -180 180
set gxout grfill
ocem1 = (ocem001+ocem002)*30*86400*1000
ocem2 = (ocem001.2+ocem002.2)*30*86400*1000
set clevs -1.0 -.5 -.2 -.1 .1 .2 .5 1.0
d ocem1-ocem2
cbarn
printim ctmdiff.ocem.png white

c
set grads off
set lon -180 180
set gxout grfill
ocwt1 = (ocwt002+ocsv002)*30*86400*1000
ocwt2 = (ocwt002.2+ocsv002.2)*30*86400*1000
set clevs -.2 -.1 -.05 -.01 .01 .05 .1 .2
d ocwt1-ocwt2
cbarn
printim ctmdiff.ocwt.png white




c
set grads off
set lon -180 180
set gxout grfill
ocwt1 = (supso4aq+supso4wt)*30*86400*1000
ocwt2 = (supso4aq.2+supso4wt.2)*30*86400*1000
set clevs -.1 -.05 -.02 -.01 .01 .02 .05 .1
d ocwt1-ocwt2
cbarn
printim ctmdiff.pso4.png white

