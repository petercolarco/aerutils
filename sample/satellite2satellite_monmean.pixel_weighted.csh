#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any odsver.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Modify below to specify kind of averaging you want: time, resolution, etc.
  set years       = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009`
  set months      = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr       = `echo qast`
  set satellites  = `echo MOD04 MYD04`
  set resolution  = `echo b`

set years      = `echo 2009`
set months     = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
set months     = `echo 03`
set satellites = `echo MOD04`
set resolution = `echo d`


  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)


# Location and time resolution of satellite data
  foreach satid ($satellites)
   foreach res ($resolution)

    if($satid != 'MOD04' && $satid != 'MYD04') then
     echo "SATID must be one of MOD04 or MYD04"
     exit 1
    endif
    if($satid == 'MOD04') set set odsver = aero_tc8_051
    if($satid == 'MYD04') set set odsver = aero_tc8_051
    set datadir   = $MODISDIR/MODIS/Level3/$satid/$res/GRITAS/
    set ntimes    = 8   # this is the number of times per day the data is saved at


#!!! Shouldn't need to edit below this line
    set regridstr = ""
#    if( $res == "a" ) set regridstr = "-geos4x5a"
#    if( $res == "b" ) set regridstr = "-geos2x25a"
#    if( $res == "c" ) set regridstr = "-geos1x125a"
#    if( $res == "d" ) set regridstr = "-geos0.5a"
#    if( $res == "e" ) set regridstr = "-geos0.25a"


#   Time loop
    foreach YYYY ( $years )
     foreach MM   ( $months )

#     QA style of averaging
#      foreach samples (1 2 3 4 5 6)
      foreach samples (1)
      if($samples == 1) set sample = ""
      if($samples == 2) set sample = "caliop1."
      if($samples == 3) set sample = "misr1."
      if($samples == 4) set sample = "caliop2."
      if($samples == 5) set sample = "misr2."
      if($samples == 6) set sample = "supermisr."

      foreach qatype  ($qastr)

       set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd)

#      Now average for the particle file wanted
       foreach datatyp ( `echo $datatype` )

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

#       QA selection
        set qawt = $qatype
        if ( $datatyp == "${satid}_L2_lnd") set qawt = ${qawt}3

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
           -func "sum(@*num(z=1),t=1,t=$ntime)/sum(maskout(num(z=1),@),t=1,t=$ntime)" \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
        /bin/rm -f tmp_qawt.${rand}.nc

        chmod g+w,g+s tmp_qawt.${rand}.nc4

        \mv -f tmp_qawt.${rand}.nc4 $datadir/Y$YYYY/M$MM/$datatyp.$sample$odsver.$qawt.pixel_weighted.$YYYY$MM.nc4

        \/bin/rm -f qawt.${rand}.ddf


       end # datatyp
      end  # QA style
      end  # Samples

     end   # MM
    end    # YYYY

   end     # res
  end      #satid

