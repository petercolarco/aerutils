#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-01-01T00:00:00 2016-01-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201601.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-02-01T00:00:00 2016-02-29T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201602.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-03-01T00:00:00 2016-03-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201603.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-04-01T00:00:00 2016-04-30T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201604.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-05-01T00:00:00 2016-05-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201605.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-06-01T00:00:00 2016-06-30T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201606.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-07-01T00:00:00 2016-07-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201607.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-08-01T00:00:00 2016-08-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201608.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-09-01T00:00:00 2016-09-30T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201609.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-10-01T00:00:00 2016-10-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201610.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-11-01T00:00:00 2016-11-30T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201611.nc
  ./trj_sampler.py -v ./CALIPSO.2017215.tle -d 6 2016-12-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.201612.nc
