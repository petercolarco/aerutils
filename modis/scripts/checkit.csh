#!/bin/tcsh -f

set satid = 'MYD04'
if($satid == 'MOD04') set set odsver = aero_tc8_005
if($satid == 'MYD04') set set odsver = aero_tc8_051

foreach res  (d)
#foreach yyyy (2000 2001 2002 2003 2004 2005 2006 2007 2008 2009)
foreach yyyy ( 2009 )
foreach mm   (01 02 03 04 05 06 07 08 09 10 11 12)
foreach qa   (qawt noqawt qawt3)

set deepblue = 0
if($qa == 'qawt3' && $satid == 'MYD04') set deepblue = 1

set domonth = 0

set file = $MODISDIR/MODIS/Level3/$satid/$res/GRITAS/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qa.$yyyy$mm.nc4
if (! -e $file) then
echo MISSING: $file
set domonth = 1
endif

set file = $MODISDIR/MODIS/Level3/$satid/$res/GRITAS/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qa.$yyyy$mm.nc4
if (! -e $file) then
echo MISSING: $file
set domonth = 1
endif

if($deepblue) then
set file = $res/GRITAS/Y$yyyy/M$mm/MOD04_L2_ocn.aero_tc8_005.$qa.$yyyy$mm.nc4
set file = $MODISDIR/MODIS/Level3/$satid/$res/GRITAS/Y$yyyy/M$mm/MYD04_L2_blu.$odsver.$qa.$yyyy$mm.nc4
if (! -e $file) then
echo $file
set domonth = 1
endif
endif

if($domonth) then
cat > tmp_checkit.pro << EOF
ods2grid, '$satid', '$yyyy${mm}01', '$yyyy${mm}31', \$
odsdir = '/misc/prc10/MODIS/Level3/$satid/ODS_03/', \$
odsver = '$odsver', \$
outdir = '/misc/prc10/MODIS/Level3/$satid/$res/GRITAS/', \$
synopticoffset=90, ntday = 8, resolution = '$res', \$
qatype = '$qa', /shave, deepblue = $deepblue
exit
EOF
idl tmp_checkit.pro
./satellite2satellite_monmean.csh $satid $res $yyyy $mm $qa
endif

end
end
end
end

