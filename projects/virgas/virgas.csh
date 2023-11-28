#!/bin/csh

# Make the trajectory sample
  ./trj_sampler.py -o GEOS5_virgas_20151022 -t csv -I csvfile.virgas_20151022.csv
  ./trj_sampler.py -o GEOS5_virgas_20151027 -t csv -I csvfile.virgas_20151027.csv
#  ./trj_sampler.py -o GEOS5_virgas_20151029 -t csv -I csvfile.virgas_20151029.csv

