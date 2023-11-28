#!/bin/tcsh
echo $GASCRP
# Make a monthly mean for various styles of sampling

  set yyyy = 2012

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    28    31    30    31    30    31    31    30    31    30    31)

  set fileout = 'H43F2010gocart2'

  foreach mm ( 01 02 03)

  set idy = 0
  while ($idy < $ndy[$mm])

  @ idy = $idy + 1
  set dd = $idy
  if($idy < 10) set dd = '0'$dd
  echo $mm$dd
 
# Now loop over possible TLE files

# nadir model at daylight for cloud fraction < 80%
  lats4d.sh -i H43F2010gocart2.tavg2d_carma_x.ctl \
            -ftype xdf -vars suexttau \ # -mean \
            -time 0z$dd$mon[$mm]$yyyy 23z$dd$mon[$mm]$yyyy   -o H43F2010gocart2.tavg2d_carma_x.iss1.$yyyy$mm$dd \
            -func "tle_mask(@.1,iss.ed.nodrag.tle)" 
  lats4d.sh -v -i H43F2010gocart2.tavg2d_carma_x.iss1.$yyyy$mm$dd.nc \
               -o H43F2010gocart2.tavg2d_carma_x.iss1.$yyyy$mm$dd \
               -mean -shave
  rm -f H43F2010gocart2.tavg2d_carma_x.iss1.$yyyy$mm$dd.nc


  lats4d.sh -i H43F2010gocart2.tavg2d_carma_x.ctl \
            -ftype xdf -vars suexttau \ # -mean \
            -time 0z$dd$mon[$mm]$yyyy 23z$dd$mon[$mm]$yyyy   -o H43F2010gocart2.tavg2d_carma_x.iss2.$yyyy$mm$dd \
            -func "tle_mask(@.1,iss.pete.nodrag.tle)" 
  lats4d.sh -v -i H43F2010gocart2.tavg2d_carma_x.iss2.$yyyy$mm$dd.nc \
               -o H43F2010gocart2.tavg2d_carma_x.iss2.$yyyy$mm$dd \
               -mean -shave
  rm -f H43F2010gocart2.tavg2d_carma_x.iss2.$yyyy$mm$dd.nc


  lats4d.sh -i H43F2010gocart2.tavg2d_carma_x.ctl \
            -ftype xdf -vars suexttau \ # -mean \
            -time 0z$dd$mon[$mm]$yyyy 23z$dd$mon[$mm]$yyyy   -o H43F2010gocart2.tavg2d_carma_x.tomcat.$yyyy$mm$dd \
            -func "dualissorbit(@.1)" 
  lats4d.sh -v -i H43F2010gocart2.tavg2d_carma_x.tomcat.$yyyy$mm$dd.nc \
               -o H43F2010gocart2.tavg2d_carma_x.tomcat.$yyyy$mm$dd \
               -mean -shave
  rm -f H43F2010gocart2.tavg2d_carma_x.tomcat.$yyyy$mm$dd.nc


end

end
