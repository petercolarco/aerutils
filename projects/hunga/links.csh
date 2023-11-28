#!/bin/csh

cd /science/gmao/geosccm/data/Hunga-Tonga/

foreach expid (C90c_HTcntl_b C90c_HTcntl_c C90c_HTcntl_d )
 cd $expid/Y2022
 foreach MM (01 02 03 04 )
  cd M$MM
  pwd
#  rm -f $expid.tavg24_3d_dad_Np.monthly.2022$MM.nc4
  ln -s ../../../C90c_HTcntl/Y2022/M$MM/C90c_HTcntl.tavg24_3d_aer_Np.monthly.2022$MM.nc4 $expid.tavg24_3d_aer_Np.monthly.2022$MM.nc4
  cd ..
 end
 cd ../../
end
