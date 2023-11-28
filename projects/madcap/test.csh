#!/bin/tcsh

# Make a monthly mean for various styles of sampling

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    29    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'c180R_pI33p7'

  foreach mm (01 02)# 03 04 05 06 07 08 09 10 11 12)

  

# Full model at daylight
  lats4d.sh -v -i c180R_pI33p7.3hr_surf.ddf -ftype xdf -vars swtnet swtnetna swtnetc swtnetcna -mean \
            -time 15z1$mon[$mm]2016 15z$ndy[$mm]$mon[$mm]2016 8   -o ${fileout}.test.swtnet.monthly.2016$mm \
            -func "maskout(@.1,@.1-0.001)" 
#            -func "maskout(@.1,if(cosz(@.1,h)>0,1,-1))" 

end
