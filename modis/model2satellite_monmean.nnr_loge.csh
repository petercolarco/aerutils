#!/bin/tcsh
# This code will use lats4d to make monthly means of the model
# as weighted by the satellite observations selected
# Arguments are SATID for satellite (MOD04, MYD04), RES for 
# resolution (a,b,c,d,e)

# Model parameters (to be modified)
  set expid      = dR_arctas
  set resolution = d
  set coll       = inst2d_hwl_x
  set expdir     = /misc/prc14/colarco/${expid}/inst2d_hwl_x/
  set expstr     = ${expid}.${coll}
  set ntimes     = 24       # number of times per day

# What fields/levels to extract?
#  set varstr = "du001 du002 du003 du004 du005 ss001 ss002 ss003 ss004 ss005 ocphilic ocphobic bcphilic bcphobic so4"
#  set levstr = "-levs 5.5e-7"
  set varstr = "duexttau ssexttau suexttau bcexttau ocexttau "
  set levstr = ""
  set regridstr = ""

# Code needs some work on selecting on dimensioning
  set years  = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009`
  set years  = `echo 2008`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set months = `echo 04`
  set satellites = `echo MOD04 MYD04`
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

     @ ntime = $ntimes * $ndays
     echo $ntime

     @ nhr   = 24 / $ntimes
     set starttime  = 0z01$month[$MM]$YYYY
     set middletime = 12z15$month[$MM]$YYYY 
     set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
     echo $tdefstr


# ddf for input files
cat > ${expstr}.${rand}.ddf << EOF
dset $expdir/Y$YYYY/M$MM/$expstr.%y4%m2%d2_%h200z.nc4
options template
$tdefstr
EOF

   # First subset possibly large input files
     lats4d.sh -v -i ${expstr}.${rand}.ddf -o tmp_aer.${rand} \
               -vars $varstr $levstr




# Satellite data
  foreach satid ($satellites)

  if($satid != 'MOD04' && $satid != 'MYD04') then
   echo "SATID must be one of MOD04 or MYD04"
   exit 1
  endif
  if($satid == 'MOD04') set set odsver = nnr_001
  if($satid == 'MYD04') set set odsver = nnr_001

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


  set datadir   = /misc/prc10/MODIS/NNR/$satid/$resolution/
  
  set datatype = ( ${satid}_l3a.ocean ${satid}_l3a.land )

   foreach datatyp ( `echo $datatype` )

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$odsver.$datatyp.%y4%m2%d2_%h200z.nc4
options template
$tdefstr
EOF

   # Pass subset to extraction
     lats4d.sh -v -i tmp_aer.${rand}.nc -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
                     -func "exp(ave(maskout(log(@.1+0.01),tau_.2(z=1)),t=1,t=$ntime))-0.01" \
                     -time $middletime $middletime

   # Regrid and shave
     lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr

   # clean-up
     rm -f tmp_qawt.${rand}.nc
     rm -f qafl.${rand}.ddf
     chmod g+w,g+s tmp_qawt.${rand}.nc4

     mv -f tmp_qawt.${rand}.nc4 $expdir/Y$YYYY/M$MM/$expstr.$odsver.loge.$datatyp.$YYYY$MM.nc4

   end # loop over datatyp


  end # end of loop over satellites

  rm -f tmp_aer.${rand}.nc
  rm -f ${expstr}.${rand}.ddf

  end # end loop over months
  end # end of time years
