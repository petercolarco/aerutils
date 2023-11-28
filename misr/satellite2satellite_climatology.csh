#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any algorithm.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Specify the resolution as input (a, b, c, d, e)
  if ( $#argv < 1 ) then
   echo "Insufficient arguments for satellite2satellite_climatology"
   exit 1
  endif

  set res = $1

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
  set nyears = 12
  set year0 = 2000
 
  set datadir   = /misc/prc10/MISR/Level3/$res/GRITAS/
  mkdir -p $datadir/clim

  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

# Time loop
  foreach MM   ( 01 02 03 04 05 06 07 08 09 10 11 12 )


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
  @ ntime = $nyears
  set starttime  = 12z15$month[$MM]$year0
  set middletime = 12z15$month[$MM]$year0
  set tdefstr = "tdef time "$ntime" linear "$starttime" 12mo"
  echo $tdefstr

cat > qawt.${rand}.ddf << EOF
dset $datadir/Y%y4/M$MM/$datatyp.$algorithm.$qawt.%y4%m2.nc4
options template
$tdefstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y%y4/M$MM/$datatyp.$algorithm.$qafl.%y4%m2.nc4
options template
$tdefstr
EOF

# Average the AOT
  lats4d.sh -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
     -func "sum(@.1*qasum.2(z=1),t=1,t=$ntime)/sum(maskout(qasum.2(z=1),@.1),t=1,t=$ntime)" \
     -time $middletime $middletime 
  lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
  /bin/rm -f tmp_qawt.${rand}.nc

# Average the QAFL
  lats4d.sh -i qafl.${rand}.ddf -j qawt.${rand}.ddf -o tmp_qafl.${rand} \
     -func "ave(maskout(@.1,aodtau.2(z=1)),t=1,t=$ntime)" \
     -time $middletime $middletime
  lats4d.sh -i tmp_qafl.${rand}.nc -o tmp_qafl.${rand} -shave $regridstr
  rm -f tmp_qafl.${rand}.nc

  chmod g+w,g+s tmp_qawt.${rand}.nc4
  chmod g+w,g+s tmp_qafl.${rand}.nc4

  \mv -f tmp_qawt.${rand}.nc4 $datadir/clim/$datatyp.$algorithm.$qawt.clim$MM.nc4
  \mv -f tmp_qafl.${rand}.nc4 $datadir/clim/$datatyp.$algorithm.$qafl.clim$MM.nc4

  \/bin/rm -f qawt.${rand}.ddf
  \/bin/rm -f qafl.${rand}.ddf


  end
  end

  end # end of time loop

