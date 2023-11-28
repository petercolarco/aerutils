#!/bin/tcsh
# This code will use lats4d to make monthly means of the model
# as weighted by the satellite observations selected

# Code needs some work on selecting on dimensioning
  set YYYY  = `echo 2007`
  set qastr  = `echo noqawt`
  set satellites = `echo MISR`

  set exps = (1 2 3 4 5 6 7 8)
  set expids = (F25b18 cR_F25b18 dR_F25b18 eR_F25b18 c48R_G40b11 c90R_G40b11 c180R_G40b11 dR_MERRA-AA-r2)
  set ress   = (b c d e b c d d)

  foreach jj (`echo $exps`)

# Model parameters
  set res       = $ress[$jj]
  set expid     = $expids[$jj]
  set coll      = inst2d_hwl_x
  set expdir    = /misc/prc14/colarco/${expid}/${coll}/
  set expstr    = ${expid}.${coll}.monthly
  set ntimes    = 24       # number of times per day

  set ndays = 92
  if($YYYY == '2000' || $YYYY == '2004' || $YYYY == '2008' || \
     $YYYY == '2012' || $YYYY == '2016') set ndays = 366

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

		    @ ntime = $ntimes * $ndays
		    echo $ntime

		    @ nhr   = 24 / $ntimes
		    set starttime  = 0z01aug$YYYY
		    set middletime = 12z15sep$YYYY 
#		    set middletime = $starttime
		    set tdefstr = "tdef time "$ntime" linear "$starttime" "$nhr"hr"
#		    echo $tdefstr

set tdefstr = "tdef time 3 linear 12z15aug2007 1mo"
set ntime   = 3
echo $tdefstr

cat > ${expstr}.${rand}.ddf << EOF
dset $expdir/Y$YYYY/M%m2/$expstr.%y4%m2.nc4
options template
$tdefstr
$lonstr
$latstr
EOF

  # Average the AOT
#  set varstr = "du001 du002 du003 du004 du005 ss001 ss002 ss003 ss004 ss005 ocphilic ocphobic bcphilic bcphobic so4"
#  set levstr = "-levs 5.5e-7"
  set varstr = "duexttau ssexttau suexttau bcexttau ocexttau totexttau"
  set levstr = ""

# First subset possibly large input files
  lats4d.sh -v -i ${expstr}.${rand}.ddf -o tmp_aer.${rand} \
     -mxtimes $ntime -vars $varstr $levstr -mean

# Regrid and shave
  lats4d.sh -i tmp_aer.${rand}.nc -o tmp_aer.${rand} -shave $regridstr

# clean-up
  rm -f tmp_aer.${rand}.nc
  chmod g+w,g+s tmp_aer.${rand}.nc4

  mv -f tmp_aer.${rand}.nc4 $expdir/Y$YYYY/$expstr.${YYYY}ASO.nc4

  \/bin/rm -f ${expstr}.${rand}.ddf
  \/bin/rm -f qafl.${rand}.ddf


	    end # loop over land/ocean
	end # loop over qa type
end # loop over satellites

end

