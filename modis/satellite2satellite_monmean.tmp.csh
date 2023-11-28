#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any odsver.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Modify below to specify kind of averaging you want: time, resolution, etc.
  set years       = `echo 2003 2004 2005 2006 2007 2008 2009 2010 2011`
  set months      = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set satellites  = `echo MYD04`
  set resolution  = `echo d`
  set ntimes    = 24   # this is the number of times per day the data is saved at

  set years       = `echo 2009`
  set months      = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set satellites  = `echo MOD04 MYD04`
  set resolution  = `echo b d`
  set ntimes    = 1   # this is the number of times per day the data is saved at


  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)


# Location and time resolution of satellite data
  foreach satid ($satellites)
   foreach res ($resolution)

    set datadir   = $MODISDIR/MODIS/Level3/$satid/$res/GRITAS/hourly/
    set datadir   = $satid/$res/GRITAS/

    if($satid != 'MOD04' && $satid != 'MYD04') then
     echo "SATID must be one of MOD04 or MYD04"
     exit 1
    endif
    if($satid == 'MOD04') set set odsver = aero_tc8_051
    if($satid == 'MYD04') set set odsver = aero_tc8_051

#!!! Shouldn't need to edit below this line
    set regridstr = ""
    if( $res == "a" ) set regridstr = "-geos4x5a"
    if( $res == "b" ) set regridstr = "-geos2x25a"
    if( $res == "c" ) set regridstr = "-geos1x125a"
    if( $res == "d" ) set regridstr = "-geos0.5a"
    if( $res == "e" ) set regridstr = "-geos0.25a"


#   Time loop
    foreach YYYY ( $years )
     foreach MM   ( $months )

       set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd )
       set datatype = ( ${satid}_L2_ocn )
#       if( $odsver == "aero_tc8_051" && $qatype == "qawt3") then
#        set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd ${satid}_L2_blu)
#       endif

#      Now average for the particle file wanted
       foreach datatyp ( `echo $datatype` )

        set qatype = qawt
        if($datatyp != ${satid}_L2_ocn) set qatype = qawt3
        set z550 = 6
        if($datatyp == ${satid}_L2_lnd) set z550 = 2

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

#       QA selection
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

#       Create the DDF files for the data set
        set ndays = $ndaysmon[$MM]
        if( $MM == 02 && ($YYYY == 2000 || $YYYY == 2004 || $YYYY == 2008)) then
         set ndays = 29
        endif

        @ ntime = $ntimes * $ndays
        @ nhr   = 24 / $ntimes
        set starttime  = 0z01$month[$MM]$YYYY
        set middletime = 12z15$month[$MM]$YYYY 
        set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
        echo $tdefstr

cat > qawt.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$datatyp.$odsver.$qawt.%y4%m2%d2.nc4
options template
$tdefstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$datatyp.$odsver.$qafl.%y4%m2%d2.nc4
options template
$tdefstr
EOF

#       Average the AOT
        lats4d.sh -v -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
           -func "sum(@.1*qasum.2(z=1),t=1,t=$ntime)/sum(maskout(qasum.2(z=1),@.1(z=$z550)),t=1,t=$ntime)" \
           -levs 550 \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
        /bin/rm -f tmp_qawt.${rand}.nc

##       Average the Fine Mode AOT
#        lats4d.sh -v -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_fine.${rand} \
#           -func "sum(@.1*finerat.2(z=1)*qasum.2(z=1),t=1,t=$ntime)/sum(maskout(qasum.2(z=1),@.1),t=1,t=$ntime)" \
#           -time $middletime $middletime
#        lats4d.sh -v -i tmp_fine.${rand}.nc -o tmp_fine.${rand} -shave $regridstr
#        /bin/rm -f tmp_fine.${rand}.nc

#       Average the QAFL
        lats4d.sh -v -i qafl.${rand}.ddf -j qawt.${rand}.ddf -o tmp_qafl.${rand} \
           -func "sum(maskout(@.1,aodtau.2(z=$z550)),t=1,t=$ntime)" \
           -vars num qasum \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qafl.${rand}.nc -o tmp_qafl.${rand} -shave $regridstr
        rm -f tmp_qafl.${rand}.nc

        chmod g+w,g+s tmp_qawt.${rand}.nc4
        chmod g+w,g+s tmp_qafl.${rand}.nc4
#        chmod g+w,g+s tmp_fine.${rand}.nc4

        \mv -f tmp_qawt.${rand}.nc4 $datadir/Y$YYYY/M$MM/$datatyp.$odsver.$qawt.$YYYY$MM.nc4
        \mv -f tmp_qafl.${rand}.nc4 $datadir/Y$YYYY/M$MM/$datatyp.$odsver.$qafl.$YYYY$MM.nc4
#        \mv -f tmp_fine.${rand}.nc4 $datadir/Y$YYYY/M$MM/$datatyp.$odsver.${qawt}_fineaot.$YYYY$MM.nc4

        \/bin/rm -f qawt.${rand}.ddf
        \/bin/rm -f qafl.${rand}.ddf


       end # datatyp

     end   # MM
    end    # YYYY

   end     # res
  end      #satid

