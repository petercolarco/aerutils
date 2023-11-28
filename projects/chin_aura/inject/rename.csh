#!/bin/csh
 set i = 0
 foreach file (`\ls -1 c48R_H40_aura.tavg2d_aer_x.2007*png`)
  @ i = $i + 1
  set ii = $i
  if($i < 10) set ii = '0'$ii
  mv $file $file:r:r.$ii.png
  echo $ii
 end
