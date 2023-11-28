#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  ./trj_sampler.py -v -t csv  -I -r trj_sampler.rc -o calipso.nc calipso.csv
  ./trj_sampler.py -v -t csv  -I -r trj_sampler_ze.rc -o calipso_ze.nc calipso.csv
