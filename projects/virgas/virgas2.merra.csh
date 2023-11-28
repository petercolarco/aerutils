#!/bin/csh

# Make the trajectory sample
  ./trj_sampler.py -r trj_sampler.merra2.rc -o GEOS5_virgas2_merra2_20151020 -t csv -I csvfile2.virgas_20151020.csv
  ./trj_sampler.py -r trj_sampler.merra2.rc -o GEOS5_virgas2_merra2_20151022 -t csv -I csvfile2.virgas_20151022.csv
  ./trj_sampler.py -r trj_sampler.merra2.rc -o GEOS5_virgas2_merra2_20151027 -t csv -I csvfile2.virgas_20151027.csv
  ./trj_sampler.py -r trj_sampler.merra2.rc -o GEOS5_virgas2_merra2_20151029 -t csv -I csvfile2.virgas_20151029.csv
  ./trj_sampler.py -r trj_sampler.merra2.rc -o GEOS5_virgas2_merra2_20151030 -t csv -I csvfile2.virgas_20151030.csv
