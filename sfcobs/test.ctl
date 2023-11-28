./extract_stations.x -rc sfcobs_locs.dat \
   -i /misc/prc10/colarco/CF_control/tavg2d_carma_x/Y%y4/M%d2/CF_control.tavg2d_carma_x.monthly.%y4%d2.nc4 \
   -o ./CF_control.tavg2d_carma_x.monthly.%s.2000.nc4 \
   -e CF_control \
   -vars ducmass \
   -nymd 20000101 -nhms 120000 -timestep 240000
