#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  ./trj_sampler.py -v ./aqua.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.aqua.2016.nc
  ./trj_sampler.py -v ./aqua.nodrag.tle -d 60 2016-01-01T00:00:00 2016-12-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.aqua.nodrag.2016.nc
