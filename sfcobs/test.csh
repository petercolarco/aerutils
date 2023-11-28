./extract_stations.x -rc sfcobs_locs.dat \
   -i /misc/prc10/colarco/CR_control/tavg2d_carma_x/Y%y4/M%m2/CR_control.tavg2d_carma_x.%y4%m2%d2_%h230z.nc4 \
   -o ./CR_control.tavg2d_carma_x.%s.2000.nc4 \
   -e CR_control \
   -vars ducmass \
   -nymd 20000101 -nhms 013000 -timestep 030000
