#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  ./swath_sampler.py -v ./ISS.2017213.tle -d 6 -w 100. 2016-01-01T00:00:00 2016-01-01T23:00:00 -I -r c180R_pI33p7.rc -o c180R_pI33p7.swath.201601.nc

