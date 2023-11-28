#!/bin/tcsh
# This code will use lats4d to make monthly means of the model
# as weighted by the satellite observations selected
# Arguments are SATID for satellite (MOD04, MYD04), RES for 
# resolution (a,b,c,d,e)

# Model parameters (to be modified)
  set expid      = dR_Fortuna-2-4-b4
  set resolution = d
  set coll       = inst2d_hwl_x
  set expdir     = /misc/prc15/colarco/${expid}/${coll}/
  set expstr     = ${expid}.${coll}
  set ntimes     = 8      # number of times per day on input file

# What fields/levels to extract?
  set varstr = "-vars totexttau totscatau totangstr "
#  set varstr = ""
  set levstr = ""
  set regridstr = ""

# Code needs some work on selecting on dimensioning
  set years  = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009`
  set years  = `echo 2007 2008 2009 2010`
  set years  = `echo 2009`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set satellites = `echo MOD04`
  set samples = `echo aero_tc8_051.qast misr1.aero_tc8_051.qast misr2.aero_tc8_051.qast caliop1.aero_tc8_051.qast caliop2.aero_tc8_051.qast supermisr.aero_tc8_051.qast`
  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

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


# Time loop
  foreach YYYY ( $years )
   foreach MM   ( $months )

     set ndays = $ndaysmon[$MM]
     if( $MM == 02 && ($YYYY == 2000 || $YYYY == 2004 || $YYYY == 2008)) then
	set ndays = 29
     endif

     set iday = 1
     while ($iday <= $ndays)
      set DD = $iday
      if($iday < 10) set DD = '0'$DD

    # generate a random number for the strings
      set rand = `ps -A | sum | cut -c1-5`

# DDF for the model
cat > ${expstr}.${rand}.ddf << EOF
dset $expdir/Y$YYYY/M$MM/$expstr.%y4%m2%d2_%h200z.nc4
options template
tdef time 8 linear 00z$DD$month[$MM]$YYYY 3hr
EOF

      set middletime = 12z$DD$month[$MM]$YYYY

      foreach satid ($satellites)
       set datadir   = /misc/prc10/MODIS/Level3/$satid/$resolution/GRITAS/
       set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd )
       foreach datatyp ( `echo $datatype` )
        foreach sample ( $samples )
if ( $datatyp == "${satid}_L2_lnd" ) set sample = ${sample}3

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$datatyp.$sample.%y4%m2%d2.nc4
options template
tdef time 8 linear 00z$DD$month[$MM]$YYYY 3hr
EOF
echo $YYYY $MM $DD $sample $datatyp
      # Pass subset to extraction
        lats4d.sh -v -i ${expstr}.${rand}.ddf -j qafl.${rand}.ddf -o tmp.${rand} \
                        -func "ave(maskout(@.1,aot.2(z=1)),t=1,t=8)" \
                        $varstr \
                        -time $middletime $middletime >> /dev/null

      # Regrid and shave
        lats4d.sh -i tmp.${rand}.nc -o tmp.${rand} -shave $regridstr >> /dev/null

      # clean-up
        rm -f tmp.${rand}.nc
        rm -f qafl.${rand}.ddf
        chmod g+w,g+s tmp.${rand}.nc4

        mv -f tmp.${rand}.nc4 $expdir/Y$YYYY/M$MM/$expstr.$datatyp.$sample.$YYYY$MM$DD.nc4

       end # loop over samples

      end # loop over datatyp

     end # end of loop over satellites

     rm -f ${expstr}.${rand}.ddf

    @ iday = $iday + 1

    end # end loop over days
  end # end loop over months
  end # end of time years
