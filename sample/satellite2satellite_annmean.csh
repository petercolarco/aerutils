#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any odsver.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Modify below to specify kind of averaging you want: time, resolution, etc.
  set years       = `echo 2016`
  set qastr       = `echo qast`
  set satellites  = `echo MYD04`
  set resolution  = `echo b c d`

# Location and time resolution of satellite data
  foreach satid ($satellites)
   foreach res ($resolution)

    if($satid != 'MOD04' && $satid != 'MYD04') then
     echo "SATID must be one of MOD04 or MYD04"
     exit 1
    endif
    if($satid == 'MOD04') set set odsver = aero_tc8_006
    if($satid == 'MYD04') set set odsver = aero_tc8_006
    set datadir   = $MODISDIR/Level3/$satid/hourly/$res/GRITAS/


#!!! Shouldn't need to edit below this line
    set regridstr = ""
#    if( $res == "a" ) set regridstr = "-geos4x5a"
#    if( $res == "b" ) set regridstr = "-geos2x25a"
#    if( $res == "c" ) set regridstr = "-geos1x125a"
#    if( $res == "d" ) set regridstr = "-geos0.5a"
#    if( $res == "e" ) set regridstr = "-geos0.25a"
#    if( $res == "ten" ) set regridstr = "-geos10x10a"


#   Time loop
    foreach YYYY ( $years )

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

      foreach qatype  ($qastr)

       set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd)

#      Now average for the particle file wanted
       foreach datatyp ( `echo $datatype` )

#       generate a random number for the strings
        set rand = `ps -A | sum | cut -c1-5`

#       QA selection
        set qawt = $qatype
        if ( $datatyp == "${satid}_L2_lnd" ) set qawt = ${qawt}3

        set starttime  = 12z15jan$YYYY
        set middletime = 12z15jun$YYYY 
        set tdefstr = "tdef time 12 linear "$starttime" 732hr"
        echo $tdefstr

cat > qawt.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M%m2/$datatyp.$sample$odsver.${qawt}_qawt.%y4%m2.nc4
options template
$tdefstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M%m2/$datatyp.$sample$odsver.${qawt}_qafl.%y4%m2.nc4
options template
$tdefstr
EOF

#       Average the AOT
        lats4d.sh -v -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
           -func "sum(@.1*qasum.2,t=1,t=12)/sum(qasum.2,t=1,t=12)" \
           -vars aot \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
        /bin/rm -f tmp_qawt.${rand}.nc

#       Average the QAFL
        lats4d.sh -v -i qafl.${rand}.ddf -j qawt.${rand}.ddf -o tmp_qafl.${rand} \
           -func "sum(@.1,t=1,t=12)" \
           -vars num qasum \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qafl.${rand}.nc -o tmp_qafl.${rand} -shave $regridstr
        rm -f tmp_qafl.${rand}.nc

        chmod g+w,g+s tmp_qawt.${rand}.nc4
        chmod g+w,g+s tmp_qafl.${rand}.nc4

        \mv -f tmp_qawt.${rand}.nc4 $datadir/Y$YYYY/$datatyp.$sample$odsver.${qawt}_qawt.$YYYY.nc4
        \mv -f tmp_qafl.${rand}.nc4 $datadir/Y$YYYY/$datatyp.$sample$odsver.${qawt}_qafl.$YYYY.nc4

        \/bin/rm -f qawt.${rand}.ddf
        \/bin/rm -f qafl.${rand}.ddf


       end # datatyp
      end  # QA style
      end  # Samples

     end   # MM
    end    # YYYY

   end     # res
  end      #satid

