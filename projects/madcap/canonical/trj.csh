#!/bin/tcsh
  set startpath = `pwd`
  cd /discover/nobackup/pcolarco/GAAS.git/GAAS
  esma
  g5

  cd $startpath
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o dust.ocean.20060605.nc dust.ocean.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o smoke.ocean.20060930.nc smoke.ocean.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o pollution.ocean.20060430.nc pollution.ocean.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o marine.20061223.nc marine.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o clean.ocean.20061113.nc clean.ocean.csv

  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o dust.land.20060605.nc dust.land.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o smoke.land.20060930.nc smoke.land.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o pollution.land.20060430.nc pollution.land.csv
  ./trj_sampler.py -v -t csv -I -r aer_Nv.rc -o clean.land.20061113.nc clean.land.csv
