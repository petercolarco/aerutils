sdfopen  /misc/prc18/colarco/c180R_pI33p7/c180R_pI33p7.tavg3d_aer_p.monthly.201607.nc4 
*sdfopen  /misc/prc18/colarco/c180R_J10p12p3dev_asd/c180R_J10p12p3dev_asd.tavg3d_aer_p.monthly.201907.nc4 
*sdfopen  /misc/prc18/colarco/c180R_J10p12p3dev_asd_fp/c180R_J10p12p3dev_asd_fp.tavg3d_aer_p.monthly.201907.nc4 
*sdfopen  /misc/prc18/colarco/c180R_J10p12p3/c180R_J10p12p3.tavg3d_aer_p.monthly.201907.nc4 


set x 1
set lev 1000 100
set zlog on
set gxout shaded
set clevs 1 2 5 10 20 50
d ave(du,lon=-180,lon=180)*1e9
cbarn

printim c180R_pI33p7.dumass.png white
