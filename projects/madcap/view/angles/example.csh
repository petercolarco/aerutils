#!/bin/tcsh

set wrkdir = `pwd`

cd /share/colarco/GAAS
setenv ESMADIR `pwd`
cd src
source g5_modules
cd Components/missions/A-CCP

cd $wrkdir

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    28    31    30    31    30    31    31    30    31    30    31)

  foreach mm ( 06)
#  foreach mm ( 01 02 03 04 05 06 07 08 09 10 11 12)

  set idy = 0
  while ($idy < $ndy[$mm])

  @ idy = $idy + 1
  set dd = $idy
  if($idy < 10) set dd = '0'$dd

  foreach hh (00 01 02 03 04 05 06 07 08 09 10 11 \
              12 13 14 15 16 17 18 19 20 21 22 23 )

  echo $mm$dd$hh

./polarimeter_swath.py -v 2006-${mm}-${dd}T${hh}:00:00 2006-${mm}-${dd}T${hh}:59:59 \
                          traj_files.pcf gpm.pcf polar07.pcf

  end

  end

  end
