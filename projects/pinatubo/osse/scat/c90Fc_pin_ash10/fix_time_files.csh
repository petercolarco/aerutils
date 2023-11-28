#!/bin/tcsh
# Issue seems to be 1991 simulation of Pinatubo time stamps files in 1991 
# time, and I want to treat like it's 2007.  Also, using a single monthly
# file and want to duplicate it 8 times.  So, grab file and mod times 
# using NCO

#set fileinp = /misc/prc18/colarco/c90Fc_H54p3_pin/tavg3d_carma_v/c90Fc_H54p3_pin.tavg3d_carma_v.monthly.199107.nc4

foreach dd (14 15 16 17 18)
foreach hh (00 03 06 09 12 15 18 21)

ncatted -O -a units,time,m,c,'minutes since 2007-06-'${dd}' '${hh}':00:00' -a time_increment,time,m,l,30000 -a begin_date,time,m,l,200706${dd} -a begin_time,time,m,l,${hh}0000 /misc/prc18/colarco/c360Fc_asdI10_pin/inst3d_carma_v/c360Fc_asdI10_pin.inst3d_carma_v.199106${dd}_${hh}00z.nc4 

ln -s /misc/prc18/colarco/c360Fc_asdI10_pin/inst3d_carma_v/c360Fc_asdI10_pin.inst3d_carma_v.199106${dd}_${hh}00z.nc4 \
      /misc/prc18/colarco/c360Fc_asdI10_pin/inst3d_carma_v/c360Fc_asdI10_pin.inst3d_carma_v.200706${dd}_${hh}00z.nc4

end
end
