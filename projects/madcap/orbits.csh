#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  ./trj_sampler.py -v ./sunsynch_450km_1330crossing.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.sunsynch_450km_1330crossing.2016_.nc
exit
  ./trj_sampler.py -v ./sunsynch_450km_1330crossing.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.sunsynch_450km_1330crossing.nodrag.2016.nc
  ./trj_sampler.py -v ./gpm.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.gpm.nodrag.2016.nc
  ./trj_sampler.py -v ./cosmos2503.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.cosmos2503.nodrag.2016.nc
  ./trj_sampler.py -v ./icesat2.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.icesat2.nodrag.2016.nc
  ./trj_sampler.py -v ./ins1a.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.ins1a.nodrag.2016.nc
  ./trj_sampler.py -v ./iss.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.iss.nodrag.2016.nc
  ./trj_sampler.py -v ./pace.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.pace.nodrag.2016.nc
  ./trj_sampler.py -v ./tiantuo2.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.tiantuo2.nodrag.2016.nc
  ./trj_sampler.py -v ./harp_30_may.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.harp_30_may.nodrag.2016.nc
  ./trj_sampler.py -v ./harp_hi_may.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.harp_hi_may.nodrag.2016.nc
  ./trj_sampler.py -v ./harp_eq_may.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.harp_eq_may.nodrag.2016.nc
  ./trj_sampler.py -v ./calipso.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.nodrag.2016.nc
  ./trj_sampler.py -v ./calipso.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.calipso.2016.nc

