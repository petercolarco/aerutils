#!/bin/tcsh

# get the aot and mass 
  lats4d.sh -i https://opendap.nccs.nasa.gov/dods/GEOS-5/fp/0.25_deg/assim/tavg3_2d_aer_Nx -o ducmass -time 01:30z15may2020 22:30z28jun2020 -ftype sdf -vars ducmass 

  lats4d.sh -i https://opendap.nccs.nasa.gov/dods/GEOS-5/fp/0.25_deg/assim/tavg3_2d_aer_Nx -o duexttau -time 01:30z15may2020 22:30z28jun2020 -ftype sdf -vars duexttau

# get the PBLH
  lats4d.sh -i https://opendap.nccs.nasa.gov/dods/GEOS-5/fp/0.25_deg/assim/tavg1_2d_flx_Nx -o pblh -time 01:30z15may2020 22:30z28jun2020 3 -ftype sdf -vars pblh
  lats4d.sh -i https://opendap.nccs.nasa.gov/dods/GEOS-5/fp/0.25_deg/assim/tavg3_3d_asm_Nv -o phis -time 01:30z15may2020 22:30z28jun2020 -ftype sdf -vars phis
