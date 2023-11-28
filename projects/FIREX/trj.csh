#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  ./trj_sampler.py -v ./ISS.2017213.tle -d 6 2016-01-01T00:00:00 2016-01-31T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.iss.201601.nc

