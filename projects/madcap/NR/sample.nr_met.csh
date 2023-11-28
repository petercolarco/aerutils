#!/bin/tcsh

# Make a monthly mean for various styles of sampling

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    28    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'c1440_NR'

  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

  

# Full model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c1440_NR.hr.ddf -j c1440_NR.hr_met.ddf \
            -ftype xdf -vars totexttau totscatau -mean \
            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.full.day.cloud.monthly.2006$mm \
            -func "maskout(maskout(@.1,if(cosz(@.1,h)>0,1,-1)),-(cldtot.2-0.8))" 
 


# Now loop over possible TLE files
  foreach tle (gpm.nodrag icesat2.nodrag iss.nodrag harp_30_may.nodrag \
               harp_eq_may.nodrag harp_hi_may.nodrag )


# 100 km model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c1440_NR.hr.ddf -j c1440_NR.hr_met.ddf \
            -ftype xdf -vars totexttau totscatau -mean \
            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.100km.day.cloud.monthly.2006$mm \
            -func "maskout(maskout(tle_mask(@.1,$tle.tle,50,50,1),if(cosz(@.1,h)>0,1,-1)),-(cldtot.2-0.8))" 

# 300 km model at daylight for cloud fraction < 80%
  lats4d.sh -v -i c1440_NR.hr.ddf -j c1440_NR.hr_met.ddf \
            -ftype xdf -vars totexttau totscatau -mean \
            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.300km.day.cloud.monthly.2006$mm \
            -func "maskout(maskout(tle_mask(@.1,$tle.tle,150,150,1),if(cosz(@.1,h)>0,1,-1)),-(cldtot.2-0.8))" 

end
 
end
