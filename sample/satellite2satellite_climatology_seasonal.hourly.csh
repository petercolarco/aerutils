#!/bin/tcsh
# This code will use lats4d to make monthly climatological means 
# of the satellite monthly mean aggregates.  Works for MODIS 
# MOD04/MYD04 files of any resolution and for any odsver.  This 
# will weight the time instance values by the variable "qasum" 
# from the *qafl files.

# Modify below to specify kind of averaging you want: time, resolution, etc.
  set months      = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr       = `echo qast`
  set satellites  = `echo MYD04`
  set resolution  = `echo d`


# Location and time resolution of satellite data
  foreach satid ($satellites)
   foreach res ($resolution)

    if($satid != 'MOD04' && $satid != 'MYD04') then
     echo "SATID must be one of MOD04 or MYD04"
     exit 1
    endif
    if($satid == 'MOD04') set set odsver = aero_tc8_051
    if($satid == 'MYD04') set set odsver = aero_tc8_051
    set datadir   = $MODISDIR/Level3/$satid/hourly/$res/GRITAS/clim/


    if($satid == 'MOD04') set odsver = aero_tc8_051
    if($satid == 'MYD04') set odsver = aero_tc8_051
    if($satid == 'MOD04') set nyears = 15
    if($satid == 'MYD04') set nyears = 12
    if($satid == 'MOD04') set year0 = 2000
    if($satid == 'MYD04') set year0 = 2003

#   Resolution
    set regridstr = ""
    if( $res == "a" ) set regridstr = "-geos4x5a"
    if( $res == "b" ) set regridstr = "-geos2x25a"
    if( $res == "c" ) set regridstr = "-geos1x125a"
    if( $res == "d" ) set regridstr = "-geos0.5a"
    if( $res == "e" ) set regridstr = "-geos0.25a"

    set month = (jan feb mar apr may jun jul aug sep oct nov dec)

#   Time loop
    mkdir -p $datadir
    set SEASON = (DJF MAM JJA SON)
    set MONTH0 = (12  3   6   9  )
    foreach SEAS   ( 1 2 3 4 )

     foreach qatype  ($qastr)

     set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd )

     foreach datatyp ( `echo $datatype` )

      set qawt = ${qastr}
      if ( $datatyp == "${satid}_L2_lnd" ) set qawt = ${qastr}3

#     generate a random number for the strings
      set rand = `ps -A | sum | cut -c1-5`

#     QA selection
      if( $datatyp == "${satid}_L2_ocn") then
       set qafl = "qast_qafl"
       set qawt = "qast_qawt"
      endif
      if( $datatyp == "${satid}_L2_lnd") then
       set qafl = "qast3_qafl"
       set qawt = "qast3_qawt"
      endif

#     Create the DDF files for the data set
      set starttime  = 0z01$month[$MONTH0[$SEAS]]$year0
      set middletime = 12z15$month[$MONTH0[$SEAS]]$year0 
      set tdefstr = "tdef time 3 linear "$starttime" 1mo"
      echo $tdefstr

cat > qawt.${rand}.ddf << EOF
dset $datadir/$datatyp.$odsver.$qawt.num.clim%m2.nc4
options template
$tdefstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/$datatyp.$odsver.$qafl.clim%m2.nc4
options template
$tdefstr
EOF

#     Average the AOT
      lats4d.sh -i qawt.${rand}.ddf -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
       -func "sum(@.1*num.2(z=1),t=1,t=3)/sum(maskout(num.2(z=1),@.1),t=1,t=3)" \
       -time $middletime $middletime
      lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr
      /bin/rm -f tmp_qawt.${rand}.nc

      chmod g+w,g+s tmp_qawt.${rand}.nc4

      \mv -f tmp_qawt.${rand}.nc4 $datadir/$datatyp.$odsver.$qawt.num.clim.$SEASON[$SEAS].nc4

      \/bin/rm -f qawt.${rand}.ddf
      \/bin/rm -f qafl.${rand}.ddf


     end # datatype
     end # qatype
    end  # season loop

   end   # resolution loop
  end    # satid loop

