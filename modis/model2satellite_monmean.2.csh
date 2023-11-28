#!/bin/tcsh
# This code will use lats4d to make monthly means of the model
# as weighted by the satellite observations selected
# Arguments are SATID for satellite (MOD04, MYD04), RES for 
# resolution (a,b,c,d,e)

# Model parameters (to be modified)
  set expid = F2_5-20040618.albaero
  set resolution = b
  set coll       = tavg2d_aer_x
  set expdir     = /misc/prc11/colarco/${expid}/
  set expstr     = ${expid}.${coll}
  set ntimes     = 1      # number of times per day on input file

# What fields/levels to extract?
#  set varstr = "du001 du002 du003 du004 du005 ss001 ss002 ss003 ss004 ss005 ocphilic ocphobic bcphilic bcpho$
#  set levstr = "-levs 5.5e-7"
  set varstr = "duexttau ssexttau suexttau bcexttau ocexttau totexttau"
  set levstr = ""
  set regridstr = ""

# Code needs some work on selecting on dimensioning
  set years  = `echo 2009`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr  = `echo qawt `
  set satellites = `echo MOD04 MYD04`
  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

# Satellite data
  foreach satid ($satellites)

  if($satid != 'MOD04' && $satid != 'MYD04') then
   echo "SATID must be one of MOD04 or MYD04"
   exit 1
  endif
  if($satid == 'MOD04') set set odsver = aero_tc8_051
  if($satid == 'MYD04') set set odsver = aero_tc8_051

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
    if($satid == 'MOD04') set algorithm = aero_tc8_051
    if($satid == 'MYD04') set algorithm = aero_tc8_051
    set datadir   = ./$satid/$resolution/GRITAS/
  
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
	    set starttime  = 9z01$month[$MM]$YYYY
	    set middletime = 12z15$month[$MM]$YYYY 
	    set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
	    echo $tdefstr


# ddf for input files
cat > ${expstr}.${rand}.ddf << EOF
dset $expdir/$expstr.%y4%m2%d2_%h200z.nc4
options template
$tdefstr
$lonstr
$latstr
EOF

          # First subset possibly large input files
            lats4d.sh -v -i ${expstr}.${rand}.ddf -o tmp_aer.${rand} \
             -vars $varstr $levstr


	    foreach qatype  ($qastr)

		set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd )
		if( $algorithm == "aero_tc8_051" && $qatype == "qawt3") then
		    set datatype = ( ${satid}_L2_ocn ${satid}_L2_lnd ${satid}_L2_blu)
		endif

		foreach datatyp ( `echo $datatype` )

                    set qawt = $qatype
                    if ( $qawt == "qawt" && $datatyp == "${satid}_L2_lnd" ) set qawt = ${qawt}3

		    # QA selection
		    if( $qawt == "qawt") then
			set qafl = "qafl"
		    endif
		    if ($qawt == "noqawt") then
			set qafl = "noqafl"  
		    endif
		    if ($qawt == "qawt3") then
			set qafl = "qafl3"  
		    endif

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$datatyp.$algorithm.$qafl.%y4%m2%d2.nc4
options template
$tdefstr
EOF

                  # Pass subset to extraction
                    lats4d.sh -v -i tmp_aer.${rand}.nc -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
                     -func "sum(@.1*qasum.2(z=1),t=1,t=$ntime)/sum(maskout(qasum.2(z=1),@.1),t=1,t=$ntime)" \
                     -time $middletime $middletime

                  # Regrid and shave
                    lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr

                  # clean-up
                    rm -f tmp_qawt.${rand}.nc
                    rm -f qafl.${rand}.ddf
                    chmod g+w,g+s tmp_qawt.${rand}.nc4

                    mv -f tmp_qawt.${rand}.nc4 $expdir/$expstr.$datatyp.$algorithm.$qawt.$YYYY$MM.nc4

	    end # loop over land/ocean
	end # loop over qa type

        rm -f tmp_aer.${rand}.nc
        rm -f ${expstr}.${rand}.ddf

    end # end loop over months
  end # end of time years

  end # end of loop over satellites
