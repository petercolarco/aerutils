#!/bin/csh
set BASEDIR = /misc/prc09/MODIS/Level3/MYD04/b/GRITAS/
cd $BASEDIR

set satid = 'MYD04'

foreach qa ('qawt' 'qafl')


if($satid == 'MOD04') then
 set lnklnd = $BASEDIR/Y2000/M02/undef.MOD04_L2_lnd.aero_005.$qa.20000224.hdf
 set lnkocn = $BASEDIR/Y2000/M02/undef.MOD04_L2_ocn.aero_005.$qa.20000224.hdf
else
 set lnklnd = $BASEDIR/Y2003/M01/undef.MYD04_L2_lnd.aero_005.$qa.20030101.hdf
 set lnkocn = $BASEDIR/Y2003/M01/undef.MYD04_L2_ocn.aero_005.$qa.20030101.hdf
endif 

foreach yyyy (2000 2001 2002 2003 2004 2005 2006 2007)
foreach mm   (01 02 03 04 05 06 07 08 09 10 11 12)
foreach dd   (01 02 03 04 05 06 07 08 09 10 \
              11 12 13 14 15 16 17 18 19 20 \
              21 22 23 24 25 26 27 28 29 30 31)

set typ = lnd
ls -l Y$yyyy/M$mm/${satid}_L2_${typ}.aero_005.$qa.$yyyy$mm$dd.hdf | grep "\->" > tmp
set result = `awk '{print $10}' tmp`
if( $result == '->') then
  rm -f Y$yyyy/M$mm/${satid}_L2_${typ}.aero_005.$qa.$yyyy$mm$dd.hdf
  ln -s $lnklnd Y$yyyy/M$mm//${satid}_L2_${typ}.aero_005.$qa.$yyyy$mm$dd.hdf
endif

set typ = ocn
ls -l Y$yyyy/M$mm/${satid}_L2_${typ}.aero_005.$qa.$yyyy$mm$dd.hdf | grep "\->" > tmp
set result = `awk '{print $10}' tmp`
if( $result == '->') then
  rm -f Y$yyyy/M$mm/${satid}_L2_${typ}.aero_005.$qa.$yyyy$mm$dd.hdf
  ln -s $lnkocn Y$yyyy/M$mm/${satid}_L2_${typ}.aero_005.$qa.$yyyy$mm$dd.hdf 
endif




end
end
end

end
