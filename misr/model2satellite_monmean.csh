#!/bin/tcsh
# This code will use lats4d to make monthly means of the model
# as weighted by the satellite observations selected

# Code needs some work on selecting on dimensioning
  set years  = `echo 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr  = `echo noqawt`
  set satellites = `echo MISR`
  set years  = `echo 2013`

# Model parameters
  set res       = d
  set expid     = dR_MERRA-AA-r2
  set coll      = inst2d_hwl_x
  set expdir    = /misc/prc15/colarco/${expid}/${coll}/
  set expstr    = ${expid}.${coll}
  set ntimes    = 24       # number of times per day

  set ndaysmon = ( 31 28 31 30 31 30 31 31 30 31 30 31 )
  set month = (jan feb mar apr may jun jul aug sep oct nov dec)

  if($res == "a") then
   set lonstr = "xdef lon 72 linear -180 5."
   set latstr = "ydef lat 46 linear -90  4."
   set regridstr = "-geos4x5a"
  endif
  if($res == "b") then
   set lonstr = "xdef lon 144 linear -180 2.5"
   set latstr = "ydef lat 91  linear -90  2."
   set regridstr = "-geos2x25a"
  endif
  if($res == "c") then
   set lonstr = "xdef lon 288 linear -180 1.25"
   set latstr = "ydef lat 181 linear -90  1."
   set regridstr = "-geos1x125a"
  endif
  if($res == "d") then
   set lonstr = "xdef lon 576 linear -180 0.625"
   set latstr = "ydef lat 361 linear -90  0.5"
   set regridstr = "-geos0.5a"
  endif
  if($res == "e") then
   set lonstr = "xdef lon 1152 linear -180 0.3125"
   set latstr = "ydef lat 721  linear -90  0.25"
   set regridstr = "-geos0.25a"
  endif


# Time loop
  foreach satid ( $satellites )
    if($satid == 'MISR') set algorithm = aero_tc8_F12_0022
    set datadir   = /science/terra/misr/data/Level3/$res/
  
    foreach YYYY ( $years )
	foreach MM   ( $months )

	    foreach qatype  ($qastr)

		set datatype = ( ${satid}_L2 )

		foreach datatyp ( `echo $datatype` )

		    # generate a random number for the strings
		    set rand = `ps -A | sum | cut -c1-5`

		    # QA selection
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
#		    set middletime = $starttime
		    set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
		    echo $tdefstr

cat > ${expstr}.${rand}.ddf << EOF
dset $expdir/Y$YYYY/M$MM/$expstr.%y4%m2%d2_%h200z.nc4
options template
$tdefstr
$lonstr
$latstr
EOF

cat > qafl.${rand}.ddf << EOF
dset $datadir/Y$YYYY/M$MM/$datatyp.$algorithm.$qafl.%y4%m2%d2.nc4
options template
$tdefstr
EOF

  # Average the AOT
#  set varstr = "du001 du002 du003 du004 du005 ss001 ss002 ss003 ss004 ss005 ocphilic ocphobic bcphilic bcphobic so4"
#  set levstr = "-levs 5.5e-7"
  set varstr = "duexttau ssexttau suexttau bcexttau ocexttau totexttau"
  set levstr = ""

# First subset possibly large input files
  lats4d.sh -v -i ${expstr}.${rand}.ddf -o tmp_aer.${rand} \
     -vars $varstr $levstr

# Pass subset to extraction
  lats4d.sh -v -i tmp_aer.${rand}.nc -j qafl.${rand}.ddf -o tmp_qawt.${rand} \
     -func "sum(@.1*qasum.2(z=1),t=1,t=$ntime)/sum(maskout(qasum.2(z=1),@.1),t=1,t=$ntime)" \
     -time $middletime $middletime

# Regrid and shave
  lats4d.sh -i tmp_qawt.${rand}.nc -o tmp_qawt.${rand} -shave $regridstr

# clean-up
  rm -f tmp_aer.${rand}.nc
  rm -f tmp_qawt.${rand}.nc
  chmod g+w,g+s tmp_qawt.${rand}.nc4

  mv -f tmp_qawt.${rand}.nc4 $expdir/Y$YYYY/M$MM/$expstr.$datatyp.$algorithm.$qawt.$YYYY$MM.nc4

  \/bin/rm -f ${expstr}.${rand}.ddf
  \/bin/rm -f qafl.${rand}.ddf


	    end # loop over land/ocean
	end # loop over qa type
    end # end loop over months
  end # end of time years
end # loop over satellites

