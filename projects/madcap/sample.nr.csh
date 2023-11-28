#!/bin/tcsh

# Make a monthly mean for various styles of sampling

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    28    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'c1440_NR'

  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

  

# Full model AOD
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau -mean \
            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.full.monthly.2006$mm

# Full model at daylight
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau -mean \
            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.full_day.monthly.2006$mm \
            -func "maskout(@.1,if(cosz(@.1,h)>0,1,-1))" 

## Full model at daylight for cloud fraction < 80%
#  lats4d.sh -v -i c1440_NR.hr.ddf -j c1440_NR.hr_surf.ddf \
#            -ftype xdf -vars totexttau -mean \
#            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.full_day_cloud.monthly.2006$mm \
#            -func "maskout(maskout(@.1,if(cosz(@.1,h)>0,1,-1)),-(cldtt.2-0.8))" 
 

# CALIPSO model AOD
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau -mean \
            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.calipso.monthly.2006$mm \
            -func "tle_mask(@.1,calipso.tle)"

# CALIPSO model at daylight
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau -mean \
            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.calipso_day.monthly.2006$mm \
            -func "maskout(tle_mask(@.1,calipso.tle),if(cosz(tle_mask(@.1,calipso.tle),h)>0,1,-1))" 

## CALIPSO model at daylight for cloud fraction < 80%
#  lats4d.sh -v -i c1440_NR.hr.ddf -j c1440_NR.hr_surf.ddf \
#            -ftype xdf -vars totexttau -mean \
#            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.calipso_day_cloud.monthly.2006$mm \
#            -func "maskout(maskout(tle_mask(@.1,calipso.tle),if(cosz(tle_mask(@.1,calipso.tle),h)>0,1,-1)),-(cldtt.2-0.8))" 
 

# Add a 100 km swath
# CALIPSO model AOD
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau -mean \
            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.calipso_swath.monthly.2006$mm \
            -func "tle_mask(@.1,calipso.tle,50,50)"

# CALIPSO model at daylight
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau -mean \
            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.calipso_swath_day.monthly.2006$mm \
            -func "maskout(tle_mask(@.1,calipso.tle,50,50),if(cosz(tle_mask(@.1,calipso.tle,50,50),h)>0,1,-1))" 

## CALIPSO model at daylight for cloud fraction < 80%
#  lats4d.sh -v -i c1440_NR.hr.ddf -j c1440_NR.hr_surf.ddf \
#            -ftype xdf -vars totexttau -mean \
#            -time 0z1$mon[$mm]2006 21z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.calipso_swath_day_cloud.monthly.2006$mm \
#            -func "maskout(maskout(tle_mask(@.1,calipso.tle,50,50),if(cosz(tle_mask(@.1,calipso.tle,50,50),h)>0,1,-1)),-(cldtt.2-0.8))" 
 


end

end
