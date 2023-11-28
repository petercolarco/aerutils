#!/bin/tcsh
  set startpath = `pwd`
  cd /share/colarco/GAAS
  esma
  g5

  cd $startpath

  set mon = ('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec')
  set ndy = ( 31    28    31    30    31    30    31    31    30    31    30    31)

  foreach mm ( 01 02 03 04 05 06 07 08 09 10 11 12)

  set idy = 0
  while ($idy < $ndy[$mm])

  @ idy = $idy + 1
  set dd = $idy
  if($idy < 10) set dd = '0'$dd

  foreach hh (00 01 02 03 04 05 06 07 08 09 10 11 \
              12 13 14 15 16 17 18 19 20 21 22 23 )

  echo $mm$dd$hh


  ./trj_sampler.py -v ./sunsynch_450km_1330crossing.nodrag.tle -d 1 2006-${mm}-${dd}T${hh}:00:00 2006-${mm}-${dd}T${hh}:59:59 -I -r c1440_NR.hr.rc -o c1440_NR.hr.sunsynch_450km_1330crossing.nodrag.2006$mm${dd}_${hh}00z.nc
  ./trj_sampler.py -v ./gpm.nodrag.tle                         -d 1 2006-${mm}-${dd}T${hh}:00:00 2006-${mm}-${dd}T${hh}:59:59 -I -r c1440_NR.hr.rc -o c1440_NR.hr.gpm.nodrag.2006$mm${dd}_${hh}00z.nc

  end

  end

  end
