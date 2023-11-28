#!/bin/tcsh

# Make a monthly mean for various styles of sampling

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    28    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'c1440_NR'

  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

  

## Full model AOD
#  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
#            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.full.monthly.2006$mm

# Full model at daylight
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.full.day.monthly.2006$mm \
            -func "maskout(@.1,if(cosz(@.1,h)>0,1,-1))" 


# Now loop over possible TLE files
#  foreach tle (gpm gpm.nodrag icesat2 icesat2.nodrag iss iss.nodrag harp_30_may harp_30_may.nodrag \
#               harp_eq_may harp_eq_may.nodrag harp_hi_may harp_hi_may.nodrag )
  foreach tle (gpm.nodrag icesat2.nodrag iss.nodrag harp_30_may.nodrag \
               harp_eq_may.nodrag harp_hi_may.nodrag )


## Nadir model AOD
#  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
#            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.monthly.2006$mm \
#            -func "tle_mask(@.1,$tle.tle)"

## Nadir model at daylight
#  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
#            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.day.monthly.2006$mm \
#            -func "maskout(tle_mask(@.1,$tle.tle),if(cosz(tle_mask(@.1,$tle.tle),h)>0,1,-1))" 


## 100 km model AOD
#  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
#            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.100km.monthly.2006$mm \
#            -func "tle_mask(@.1,$tle.tle,50,50,1)"

# 100 km model at daylight
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.100km.day.monthly.2006$mm \
            -func "maskout(tle_mask(@.1,$tle.tle,50,50,1),if(cosz(@.1,h)>0,1,-1))" 

## 300 km model AOD
#  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
#            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.300km.monthly.2006$mm \
#            -func "tle_mask(@.1,$tle.tle,150,150,1)"

# 300 km model at daylight
  lats4d.sh -v -i c1440_NR.hr.ddf -ftype xdf -vars totexttau totscatau -mean \
            -time 0z1$mon[$mm]2006 23z$ndy[$mm]$mon[$mm]2006   -o ${fileout}.$tle.300km.day.monthly.2006$mm \
            -func "maskout(tle_mask(@.1,$tle.tle,150,150,1),if(cosz(@.1,h)>0,1,-1))" 


end

end
