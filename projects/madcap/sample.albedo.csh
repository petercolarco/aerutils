#!/bin/tcsh

# Make a monthly mean for various styles of sampling

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    29    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'c180R_pI33p7'

  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)
  foreach hh (00 03 06 09 12 15 18 21)

  

# Full model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars albedo -mean \
            -time ${hh}z1$mon[$mm]2016 ${hh}z$ndy[$mm]$mon[$mm]2016 8  -o ${fileout}.full_day.albedo.monthly.2016${mm}.${hh}z \
            -func "maskout(@.1,swtnet-0.0001)" 

# Full model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -j c180R_pI33p7.3hr_surf.ddf \
            -ftype xdf -vars albedo -mean \
            -time ${hh}z1$mon[$mm]2016 ${hh}z$ndy[$mm]$mon[$mm]2016 8  -o ${fileout}.full_day_cloud.albedo.monthly.2016${mm}.${hh}z \
            -func "maskout(maskout(@.1,swtnet-0.0001),-(cldtt.2-0.8))" 
 

# CALIPSO model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars albedo -mean \
            -time ${hh}z1$mon[$mm]2016 ${hh}z$ndy[$mm]$mon[$mm]2016 8  -o ${fileout}.calipso_day.albedo.monthly.2016${mm}.${hh}z \
            -func "maskout(tle_mask(@.1,calipso.tle),tle_mask(swtnet,calipso.tle)-0.0001)" 

# CALIPSO model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -j c180R_pI33p7.3hr_surf.ddf \
            -ftype xdf -vars albedo -mean \
            -time ${hh}z1$mon[$mm]2016 ${hh}z$ndy[$mm]$mon[$mm]2016 8  -o ${fileout}.calipso_day_cloud.albedo.monthly.2016${mm}.${hh}z \
            -func "maskout(maskout(tle_mask(@.1,calipso.tle),tle_mask(swtnet,calipso.tle)-0.0001),-(cldtt.2-0.8))" 
 

# Add a 100 km swath
# CALIPSO model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars albedo -mean \
            -time ${hh}z1$mon[$mm]2016 ${hh}z$ndy[$mm]$mon[$mm]2016 8  -o ${fileout}.calipso_swath_day.albedo.monthly.2016${mm}.${hh}z \
            -func "maskout(tle_mask(@.1,calipso.tle,50,50),tle_mask(swtnet,calipso.tle,50,50)-0.0001)" 

# CALIPSO model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -j c180R_pI33p7.3hr_surf.ddf \
            -ftype xdf -vars albedo -mean \
            -time ${hh}z1$mon[$mm]2016 ${hh}z$ndy[$mm]$mon[$mm]2016 8  -o ${fileout}.calipso_swath_day_cloud.albedo.monthly.2016${mm}.${hh}z \
            -func "maskout(maskout(tle_mask(@.1,calipso.tle,50,50),tle_mask(swtnet,calipso.tle,50,50)-0.0001),-(cldtt.2-0.8))" 
 


end

end
