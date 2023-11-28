#!/bin/tcsh

# Make a monthly mean for various styles of sampling

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    29    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'c180R_pI33p7'

  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

  

# Full model AOD
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.full.swgnet.monthly.2016$mm

# Full model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.full_day.swgnet.monthly.2016$mm \
            -func "maskout(@.1,if(cosz(@.1,h)>0,1,-1))" 

# Full model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -j c180R_pI33p7.3hr_surf.ddf \
            -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.full_day_cloud.swgnet.monthly.2016$mm \
            -func "maskout(maskout(@.1,if(cosz(@.1,h)>0,1,-1)),-(cldtt.2-0.8))" 
 

# CALIPSO model AOD
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.calipso.swgnet.monthly.2016$mm \
            -func "tle_mask(@.1,calipso.tle)"

# CALIPSO model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.calipso_day.swgnet.monthly.2016$mm \
            -func "maskout(tle_mask(@.1,calipso.tle),if(cosz(tle_mask(@.1,calipso.tle),h)>0,1,-1))" 

# CALIPSO model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -j c180R_pI33p7.3hr_surf.ddf \
            -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.calipso_day_cloud.swgnet.monthly.2016$mm \
            -func "maskout(maskout(tle_mask(@.1,calipso.tle),if(cosz(tle_mask(@.1,calipso.tle),h)>0,1,-1)),-(cldtt.2-0.8))" 
 

# Add a 100 km swath
# CALIPSO model AOD
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.calipso_swath.swgnet.monthly.2016$mm \
            -func "tle_mask(@.1,calipso.tle,50,50)"

# CALIPSO model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.calipso_swath_day.swgnet.monthly.2016$mm \
            -func "maskout(tle_mask(@.1,calipso.tle,50,50),if(cosz(tle_mask(@.1,calipso.tle,50,50),h)>0,1,-1))" 

# CALIPSO model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -j c180R_pI33p7.3hr_surf.ddf \
            -ftype xdf -vars swgnet swgnetna swgnetc swgnetcna -mean \
            -time 0z1$mon[$mm]2016 21z$ndy[$mm]$mon[$mm]2016   -o ${fileout}.calipso_swath_day_cloud.swgnet.monthly.2016$mm \
            -func "maskout(maskout(tle_mask(@.1,calipso.tle,50,50),if(cosz(tle_mask(@.1,calipso.tle,50,50),h)>0,1,-1)),-(cldtt.2-0.8))" 
 


end

end
