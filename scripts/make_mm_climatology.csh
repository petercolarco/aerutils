#!/bin/csh

## Script to create aerosol climatology
## Requires GFIO_mean_r8.x executable
## datapath = path to experiment data for climatology
## expid    = name of experiment climatology from
## assumes original data in monthly means

set gfiomean = GFIO_mean_r8.x
set datapath = /misc/prc15/colarco/
set expid    = bR_Fortuna-2-4-b7
set coll     = inst3d_aer_v

### First make straight-up monthly means into proper file format
foreach YYYY (2008)
        set months = (01 02 03 04 05 06 07 08 09 10 11 12)
	#if ($YYYY == 2009) then      
	#  set months = (01 02)
	#endif
	
foreach MM ($months)             
	                       
	    set fileIn  = ${datapath}${expid}/${coll}/Y${YYYY}/M${MM}
	    set fileOut = ${expid}.aero.eta.${YYYY}${MM}mmclm.nc4

	    echo "Processing " $fileOut

	    $gfiomean -vars du001,du002,du003,du004,du005,ss001,ss002,ss003,ss004,ss005,SO4,BCphobic,BCphilic,OCphobic,OCphilic \
	    -o $fileOut \
	    -date ${YYYY}${MM}15 -time 120000 \
	    ${datapath}${expid}/${coll}/Y${YYYY}/M${MM}/$expid.$coll.monthly.$YYYY$MM.nc4
end
end

##Now make difference data
set bef = (12 01 02 03 04 05 06 07 08 09 10 11)
set now = (01 02 03 04 05 06 07 08 09 10 11 12)

set ybef = (2008)
set ynow = (2008)

set j   = 1 # year counter
foreach YY ( 2008)      

set yrbef = $ybef[$j]
set yrnow = $ynow[$j]

set i     = 1 # month counter
foreach mnow ($now)
    
    set mbef = $bef[$i]

    if ($mnow == '01') then
	if ($yrnow == '2008') then
	    set y1 = $ynow[1]
	    set y2 = $ybef[1]
	else
	    set y1 = $yrnow
	    set y2 = $yrbef
	endif
    else
	set y1 = $yrnow
	set y2 = $yrnow
    endif

	

    set fileIn1 = ${expid}.aero.eta.${y1}${mnow}mmclm.nc4 
    set fileIn2 = ${expid}.aero.eta.${y2}${mbef}mmclm.nc4
    set fileOut = ${expid}.del_aero.eta.${YY}${mnow}mmclm.nc4

    echo "Processing " $fileOut
    #echo $fileIn1
    #echo $fileIn2
    #echo $fileOut


    $gfiomean -vars du001,du002,du003,du004,du005,ss001,ss002,ss003,ss004,ss005,SO4,BCphobic,BCphilic,OCphobic,OCphilic \
    -o $fileOut \
    -date ${YY}${mnow}01 -time 000000 \
    $fileIn1 \
    -1,$fileIn2

    if ($status) exit 1
    
    @ i++

end # loop over months

@ j++
end # loop over years

exit 0


