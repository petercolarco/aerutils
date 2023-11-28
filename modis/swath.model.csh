#!/bin/tcsh

  set swath = /misc/prc10/MODIS/Level3/MOD04/c/SWATH/
  set model = /misc/prc10/colarco/t003_c32/tau/


  set YYYY = 2000
  set MM   = 02
  set DD   = 27

  foreach YYYY ( 2000 2001 2002 2003 2004 2005 2006  )
  foreach MM   ( 01 02 03 04 05 06 07 08 09 10 11 12 )
  foreach DD   ( 01 02 03 04 05 06 07 08 09 10 \
                 11 12 13 14 15 16 17 18 19 20 \
                 21 22 23 24 25 26 27 28 29 30 31 )

  set modelf = $model/Y$YYYY/M$MM/t003_c32.tau2d.v2.total.$YYYY$MM$DD.hdf
  set modelo = $model/Y$YYYY/M$MM/t003_c32.tau2d.v2.total
  set swathf = $swath/Y$YYYY/M$MM/mod04_c06.mask.sfc.$YYYY$MM$DD.nc

  if( -e $swathf) then

  lats4d -i $modelf -j $swathf -o modis -func "maskout(aodtau,modis.2)" 
  lats4d -i $modelf -j $swathf -o misr  -func "maskout(aodtau,misr.2)" 
  lats4d -i $modelf -j $swathf -o subpoint -func "maskout(aodtau,subpoint.2)" 

  h4zip modis.nc &
  h4zip misr.nc &
  h4zip subpoint.nc &
  wait

  \mv -f modis.nc    $modelo.modis.$YYYY$MM$DD.hdf
  \mv -f misr.nc     $modelo.misr.$YYYY$MM$DD.hdf
  \mv -f subpoint.nc $modelo.subpoint.$YYYY$MM$DD.hdf

  endif

  end
  end
  end

