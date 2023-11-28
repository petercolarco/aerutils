#!/bin/tcsh
# This code will use lats4d to make monthly means of the satellite
# aggregates.  Works for MODIS MOD04/MYD04 files of any resolution
# and for any odsver.  This will weight the time instance values
# by the variable "qasum" from the *qafl files.

# Modify below to specify kind of averaging you want: time, resolution, etc.
  set years       = `echo 2001`
  set satellites  = `echo MOD04`
  set resolution  = `echo b`


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


#!!! Shouldn't need to edit below this line
    set regridstr = ""
    if( $res == "a" ) set regridstr = "-geos4x5a"
    if( $res == "b" ) set regridstr = "-geos2x25a"
    if( $res == "c" ) set regridstr = "-geos1x125a"
    if( $res == "d" ) set regridstr = "-geos0.5a"
    if( $res == "e" ) set regridstr = "-geos0.25a"


#   Time loop
    foreach YYYY ( $years )

       set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd )

#      Now average for the particle file wanted
       foreach datatyp ( `echo $datatype` )

        set qatype = qawt
        if($datatyp == ${satid}_L2_lnd) set qatype = qawt3

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

        set starttime  = 12z15jan$YYYY
        set middletime = 12z15jun$YYYY 
        set tdefstr = "tdef time 12 linear "$starttime" 732hr"
        echo $tdefstr

cat > qawt.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M%m2/$datatyp.$odsver.$qawt.num.%y4%m2.nc4
options template
$tdefstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M%m2/$datatyp.$odsver.$qafl.%y4%m2.nc4
options template
$tdefstr
EOF
exit
#       Average the AOT
        lats4d.sh -v -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
           -func "sum(@.1*num.2(z=1),t=1,t=12)/sum(maskout(num.2(z=1),@.1),t=1,t=12)" \
           -time $middletime $middletime
        lats4d.sh -v -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
        /bin/rm -f tmp_qawt.${rand}.nc

##       Average the QAFL
#        lats4d.sh -v -i qafl.${rand}.ddf -j qawt.${rand}.ddf -o tmp_qafl.${rand} \
#           -func "sum(maskout(@.1,aodtau.2(z=1)),t=1,t=12)" \
#           -time $middletime $middletime
#        lats4d.sh -v -i tmp_qafl.${rand}.nc -o tmp_qafl.${rand} -shave $regridstr
#        rm -f tmp_qafl.${rand}.nc

        chmod g+w,g+s tmp_qawt.${rand}.nc4

        \mv -f tmp_qawt.${rand}.nc4 $datadir/Y$YYYY/$datatyp.$odsver.$qawt.num.$YYYY.nc4

        \/bin/rm -f qawt.${rand}.ddf
        \/bin/rm -f qafl.${rand}.ddf


       end # datatyp

    end    # YYYY

   end     # res
  end      #satid

