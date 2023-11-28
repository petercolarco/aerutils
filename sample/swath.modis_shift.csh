#!/bin/tcsh
  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/dasilva/OpenGrADS:$PATH

  set swath = /misc/prc10/MODIS/Level3/MOD04/SWATH_d/
  set model = /misc/prc10/MODIS/Level3/MOD04/d/GRITAS/

  set YYYY = 2001
  set MM   = 01
  set DD   = 01

  foreach YYYY ( 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009)
  foreach MM   ( 01 02 03 04 05 06 07 08 09 10 11 12 )
  foreach DD   ( 01 02 03 04 05 06 07 08 09 10 \
                 11 12 13 14 15 16 17 18 19 20 \
                 21 22 23 24 25 26 27 28 29 30 31 )

  set modelf = $model/Y$YYYY/M$MM/MOD04_L2_ocn.aero_tc8_005.qawt.$YYYY$MM$DD.nc4
  set modelo = $model/Y$YYYY/M$MM/MOD04_L2_ocn.aero_tc8_005.qawt.shift
  set swathf = $swath/Y$YYYY/M$MM/mod04_d-t+03hourly.mask.sfc.shift.$YYYY$MM$DD.nc4

  if( -e $swathf && -e $modelf) then

#  generate a random number for the strings
   set rand = `ps -A | sum | cut -c1-5`
   ls -l $swathf | grep "\->" > tmp.$rand
   set result = `awk '{print $10}' tmp.$rand`
   /bin/rm -f tmp.$rand
   if( $result != '->') then

#   lats4d.sh -i $modelf -j $swathf -o modis.$rand -func "maskout(aodtau,modis.2(z=1))" -shave
   lats4d.sh -i $modelf -j $swathf -o misr.$rand  -func "maskout(aodtau,misr.2(z=1))" -shave
   lats4d.sh -i $modelf -j $swathf -o subpoint.$rand -func "maskout(aodtau,subpoint.2(z=1))" -shave

#   chmod g+s,g+w modis.$rand.nc4
   chmod g+s,g+w misr.$rand.nc4 
   chmod g+s,g+w subpoint.$rand.nc4

#   \mv -f modis.$rand.nc4    $modelo.modis.$YYYY$MM$DD.nc4
   \mv -f misr.$rand.nc4     $modelo.misr.$YYYY$MM$DD.nc4
   \mv -f subpoint.$rand.nc4 $modelo.subpoint.$YYYY$MM$DD.nc4

   endif

  endif

  end
  end
  end

