#!/bin/tcsh
# This code will use lats4d to make monthly means of the model
# as weighted by the satellite observations selected
# Arguments are SATID for satellite (MOD04, MYD04), RES for 
# resolution (a,b,c,d,e)

# Model parameters (to be modified)
  set expid      = c180R_pI33p7
  set resolution = d
  set coll       = inst2d_hwl_x
  set expdir     = /misc/prc18/colarco/${expid}/${coll}/
  set expstr     = ${expid}.${coll}
  set ntimes     = 24      # number of times per day on input file

# What fields/levels to extract?
  set varstr = "-vars totexttau totscatau totangstr"
#  set varstr = ""
  set levstr = ""
  set regridstr = ""

# Code needs some work on selecting on dimensioning
  set years  = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009`
  set years  = `echo 2016`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set satellites = `echo MISR`
  set samples = `echo aero_tc8_F12_0022.noqawt`
  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

# Time loop
  foreach YYYY ( $years )
   foreach MM   ( $months )

   # generate a random number for the strings
     set rand = `ps -A | sum | cut -c1-5`

   # Create the DDF files for the data set
     set ndays = $ndaysmon[$MM]
     if( $MM == 02 && ($YYYY == 2000 || $YYYY == 2004 || $YYYY == 2008)) then
	set ndays = 29
     endif

     @ ntime    = $ntimes * $ndays
     @ ntimesat = 24 * $ndays

     @ nhr   = 24 / $ntimes
     set starttime  = 0z01$month[$MM]$YYYY
     set middletime = 12z15$month[$MM]$YYYY 
     set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
     set tdefstrsat = "tdef time "$ntimesat" linear "$starttime" "$nhr"hr"
     echo $tdefstr

   # Create a time extraction string for the subsetting
   # Coping with possibly hourly output from model but only
   # three-hourly MODIS availability
     if($nhr == 1) then
      set timestr = "00z01"$month[$MM]$YYYY" 23z"$ndays$month[$MM]$YYYY" 1"
     else
      set timestr = "00z01"$month[$MM]$YYYY" 21z"$ndays$month[$MM]$YYYY" 3"
     endif


# ddf for input files
#dset $expdir/Y$YYYY/M$MM/$expstr.%y4%m2%d2_%h200z.nc4
#dset $expdir/Y$YYYY/M$MM/$expstr.daily.%y4%m2.nc4
cat > ${expstr}.${rand}.ddf << EOF
dset $expdir/Y$YYYY/M$MM/$expstr.%y4%m2%d2_%h200z.nc4
options template
$tdefstr
EOF

#for forcing calculation

   # First subset possibly large input files
     lats4d.sh -v -i ${expstr}.${rand}.ddf -o tmp_aer.${rand} \
                     $varstr $levstr -time $timestr

# Satellite data
  foreach satid ($satellites)

  if($resolution == "a") then
   set lonstr = "xdef lon 72 linear -180 5."
   set latstr = "ydef lat 46 linear -90  4."
   set regridstr = "-geos4x5a"
  endif
  if($resolution == "b") then
   set lonstr = "xdef lon 144 linear -180 2.5"
   set latstr = "ydef lat 91  linear -90  2."
   set regridstr = "-geos2x25a"
  endif
  if($resolution == "c") then
   set lonstr = "xdef lon 288 linear -180 1.25"
   set latstr = "ydef lat 181 linear -90  1."
   set regridstr = "-geos1x125a"
  endif
  if($resolution == "d") then
   set lonstr = "xdef lon 576 linear -180 0.625"
   set latstr = "ydef lat 361 linear -90  0.5"
   set regridstr = "-geos0.5a"
  endif
  if($resolution == "e") then
   set lonstr = "xdef lon 1152 linear -180 0.3125"
   set latstr = "ydef lat 721  linear -90  0.25"
   set regridstr = "-geos0.25a"
  endif


  set datadir   = /science/terra/misr/data/Level3/$resolution/
  
  set datatype = ( ${satid}_L2)

   foreach datatyp ( `echo $datatype` )
    foreach sample ( $samples )

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$datatyp.$sample.%y4%m2%d2.nc4
options template
$tdefstrsat
EOF

   # Pass subset to extraction
     lats4d.sh -v -i tmp_aer.${rand}.nc -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
                     -func "ave(maskout(@.1,aodtau.2(z=3)),t=1,t=$ntimesat)" \
                     -time $middletime $middletime

   # Regrid and shave
     lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr

#   # Regrid and shave
#     lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.10.${rand} -shave -geos10x10a

   # clean-up
     rm -f tmp_qawt.${rand}.nc
     rm -f qafl.${rand}.ddf
     chmod g+w,g+s tmp_qawt.${rand}.nc4
     chmod g+w,g+s tmp_qawt.10.${rand}.nc4

     mv -f tmp_qawt.${rand}.nc4 \
           $expdir/Y$YYYY/M$MM/$expstr.$datatyp.$sample.$YYYY$MM.nc4
#     mv -f tmp_qawt.10.${rand}.nc4 \
#           $expdir/Y$YYYY/M$MM/$expstr.$datatyp.$sample.10deg.$YYYY$MM.nc4

    end # loop over samples

   end # loop over datatyp


  end # end of loop over satellites

  rm -f tmp_aer.${rand}.nc
  rm -f ${expstr}.${rand}.ddf

  end # end loop over months
  end # end of time years
