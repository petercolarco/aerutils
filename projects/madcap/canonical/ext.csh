#!/bin/tcsh
  set startpath = `pwd`
  cd /discover/nobackup/pcolarco/GAAS.git/GAAS
  esma
  g5

  cd $startpath
  ./ext_sampler.py -v --du --ss --su --oc --bc -i dust.ocean.20060605.nc -o dust.ocean.20060605.ext.nc 
  ./ext_sampler.py -v --du --ss --su --oc --bc -i smoke.ocean.20060930.nc -o smoke.ocean.20060930.ext.nc 
  ./ext_sampler.py -v --du --ss --su --oc --bc -i pollution.ocean.20060430.nc -o pollution.ocean.20060430.ext.nc 
  ./ext_sampler.py -v --du --ss --su --oc --bc -i marine.20061223.nc -o marine.20061223.ext.nc 
  ./ext_sampler.py -v --du --ss --su --oc --bc -i clean.ocean.20061113.nc -o clean.ocean.20061113.ext.nc

  ./ext_sampler.py -v --du --ss --su --oc --bc -i dust.land.20060605.nc -o dust.land.20060605.ext.nc
  ./ext_sampler.py -v --du --ss --su --oc --bc -i smoke.land.20060930.nc -o smoke.land.20060930.ext.nc
  ./ext_sampler.py -v --du --ss --su --oc --bc -i pollution.land.20060430.nc -o pollution.land.20060430.ext.nc
  ./ext_sampler.py -v --du --ss --su --oc --bc -i clean.land.20061113.nc -o clean.land.20061113.ext.nc

