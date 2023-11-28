sdfopen /misc/prc18/colarco/c180R_J10p12p3/tavg2d_aer_x/c180R_J10p12p3.tavg2d_aer_x.monthly.201903.nc4
sdfopen /misc/prc18/colarco/c180R_J10p12p3dev_asd/tavg2d_aer_x/c180R_J10p12p3dev_asd.tavg2d_aer_x.monthly.201903.nc4

set lon -180 180
set gxout shaded

xycomp duexttau*1.15 duexttau.2

printim duexttau.scaled.march.png white
