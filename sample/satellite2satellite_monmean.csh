#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any odsver.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Modify below to specify kind of averaging you want: time, resolution, etc.
  set years       = `echo 2016 2017`
  set months      = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr       = `echo qast`
  set satellites  = `echo MYD04 MOD04`
  set resolution  = `echo b c d`

  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

# Location and time resolution of satellite data
  foreach satid ($satellites)
   foreach res ($resolution)

    if($satid != 'MOD04' && $satid != 'MYD04') then
     echo "SATID must be one of MOD04 or MYD04"
     exit 1
    endif
    if($satid == 'MOD04') set set odsver = aero_tc8_006
    if($satid == 'MYD04') set set odsver = aero_tc8_006
    set datadir   = /science/modis/data/Level3/$satid/hourly/$res/GRITAS/
    set ntimes    = 24   # this is the number of times per day the data is saved at


#!!! Shouldn't need to edit below this line
    set regridstr = ""
    if( $res == "a" ) set regridstr = "-geos4x5a"
#    if( $res == "b" ) set regridstr = "-geos2x25a"
#    if( $res == "c" ) set regridstr = "-geos1x125a"
#    if( $res == "d" ) set regridstr = "-geos0.5a"
#    if( $res == "e" ) set regridstr = "-geos0.25a"
#    if( $res == "ten" ) set regridstr = "-geos10x10a"


#   Time loop
    foreach YYYY ( $years )
     foreach MM   ( $months )

#     QA style of averaging
#      foreach samples (1 2 3 4 5 6 7 8 9 0)
      foreach samples (1)
      if($samples == 1) set sample = ""
      if($samples == 2) set sample = "caliop1."
      if($samples == 3) set sample = "misr1."
      if($samples == 4) set sample = "caliop2."
      if($samples == 5) set sample = "misr2."
      if($samples == 6) set sample = "supermisr."
      if($samples == 7) set sample = "caliop3."
      if($samples == 8) set sample = "misr3."
      if($samples == 9) set sample = "caliop4."
      if($samples == 0) set sample = "misr4."
      if($samples == a) set sample = "inverse_caliop1."
      if($samples == b) set sample = "inverse_misr1."
      if($samples == c) set sample = "inverse_caliop2."
      if($samples == d) set sample = "inverse_misr2."
      if($samples == e) set sample = "inverse_supermisr."
      if($samples == f) set sample = "inverse_caliop3."
      if($samples == g) set sample = "inverse_misr3."
      if($samples == h) set sample = "inverse_caliop4."
      if($samples == i) set sample = "inverse_misr4."

      foreach qatype  ($qastr)

       set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd )
#       set datatype = ( ${satid}_L2_blu )

#      Now average for the particle file wanted
       foreach datatyp ( `echo $datatype` )

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

#       QA selection
        set qawt = $qatype
        if ( $datatyp == "${satid}_L2_lnd" ) set qawt = ${qawt}3

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
dset $datadir/Y$YYYY/M$MM/$datatyp.$sample$odsver.$qawt.%y4%m2%d2.nc4
options template
$tdefstr
EOF

#       Average the AOT
        lats4d.sh -v -i qawt.${rand}.ddf -o tmp_qawt.${rand} \
           -func "sum(@*qasum,t=1,t=$ntime)/sum(qasum,t=1,t=$ntime)" \
           -vars aot \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
        /bin/rm -f tmp_qawt.${rand}.nc

#       Average the QAFL
        lats4d.sh -v -i qawt.${rand}.ddf -o tmp_qafl.${rand} \
           -func "sum(@,t=1,t=$ntime)" \
           -vars num qasum \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qafl.${rand}.nc -o tmp_qafl.${rand} -shave $regridstr
        rm -f tmp_qafl.${rand}.nc

        chmod g+w,g+s tmp_qawt.${rand}.nc4
        chmod g+w,g+s tmp_qafl.${rand}.nc4

        \mv -f tmp_qawt.${rand}.nc4 $datadir/Y$YYYY/M$MM/$datatyp.$sample$odsver.${qawt}_qawt.$YYYY$MM.nc4
        \mv -f tmp_qafl.${rand}.nc4 $datadir/Y$YYYY/M$MM/$datatyp.$sample$odsver.${qawt}_qafl.$YYYY$MM.nc4

        \/bin/rm -f qawt.${rand}.ddf
        \/bin/rm -f qafl.${rand}.ddf


       end # datatyp
      end  # QA style
      end  # Samples

     end   # MM
    end    # YYYY

   end     # res
  end      #satid

