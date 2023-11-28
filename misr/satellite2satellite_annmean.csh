#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any algorithm.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Specify the resolution as input (a, b, c, d, e)
  if ( $#argv < 2 ) then
   echo "Insufficient arguments for satellite2satellite_monmean"
   exit 1
  endif

  set YYYY = $1
  set res = $2

  set regridstr = ""
  if( $res == "a" ) set regridstr = "-geos4x5a"
  if( $res == "b" ) set regridstr = "-geos2x25a"
  if( $res == "c" ) set regridstr = "-geos1x125a"
  if( $res == "d" ) set regridstr = "-geos0.5a"
  if( $res == "e" ) set regridstr = "-geos0.25a"

  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/dasilva/OpenGrADS:$PATH

  set satid = MISR
  set algorithm = aero_tc8_F12_0022
  set ntimes    = 24        # number of times per day
 
  set datadir   = /science/terra/misr/data/Level3/$res/GRITAS/

  foreach qatype  (noqawt)

  set datatype = ( ${satid}_L2 )

  foreach datatyp ( `echo $datatype` )

# generate a random number for the strings
  set rand = `ps -A | sum | cut -c1-5`

# QA selection
  if( $qatype == "qawt") then
   set qafl = "qafl"
  endif
  if ($qatype == "noqawt") then
   set qafl = "noqafl"  
  endif
  if ($qatype == "qawt3") then
   set qafl = "qafl3"  
  endif
  set qawt = $qatype

# Create the DDF files for the data set
  set ndays = 365
  if( $YYYY == 2000 || $YYYY == 2004 || $YYYY == 2008 || \
      $YYYY == 2012 ) then
   set ndays = 366
  endif

  @ ntime = $ntimes * $ndays
  @ nhr   = 24 / $ntimes
  set starttime  = 0z01jan$YYYY
  set middletime = 12z15jun$YYYY 
  set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
  echo $tdefstr

cat > qawt.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M%m2/$datatyp.$algorithm.$qawt.%y4%m2%d2.nc4
options template
$tdefstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M%m2/$datatyp.$algorithm.$qafl.%y4%m2%d2.nc4
options template
$tdefstr
EOF

# Average the AOT
  lats4d.sh -v -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
     -func "sum(@.1*qasum.2(z=1),t=1,t=$ntime)/sum(maskout(qasum.2(z=1),@.1),t=1,t=$ntime)" \
     -time $middletime $middletime 
  lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
  /bin/rm -f tmp_qawt.${rand}.nc

# Average the QAFL
  lats4d.sh -v -i qafl.${rand}.ddf -j qawt.${rand}.ddf -o tmp_qafl.${rand} \
     -func "ave(maskout(@.1,aodtau.2(z=1)),t=1,t=$ntime)" \
     -time $middletime $middletime
  lats4d.sh -i tmp_qafl.${rand}.nc -o tmp_qafl.${rand} -shave $regridstr
  rm -f tmp_qafl.${rand}.nc

  chmod g+w,g+s tmp_qawt.${rand}.nc4
  chmod g+w,g+s tmp_qafl.${rand}.nc4

  \mv -f tmp_qawt.${rand}.nc4 $datadir/Y$YYYY/$datatyp.$algorithm.$qawt.$YYYY.nc4
  \mv -f tmp_qafl.${rand}.nc4 $datadir/Y$YYYY/$datatyp.$algorithm.$qafl.$YYYY.nc4

  \/bin/rm -f qawt.${rand}.ddf
  \/bin/rm -f qafl.${rand}.ddf


  end
  end

