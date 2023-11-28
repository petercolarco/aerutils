#!/bin/tcsh

# create some DDF files for the various extracts

foreach tle (gpm.nodrag sunsynch_500km.nodrag sunsynch_450km_1330crossing.nodrag dual dual450km)

foreach swath (nadir 100 300 500 1000)

set swath_ = ${swath}km
if ( `echo $swath` == "nadir") then 
 set swath_ = $swath
endif

set ext = 'nc'
if ($tle == 'dual' || $tle == 'dual450km') set ext = 'nc4'

set file = c1440_NR.$tle.${swath_}.ddf

cat> $file <<EOF
dset /misc/prc19/colarco/c1440_NR_0.5000/day/$tle/c1440_NR.$tle.${swath_}.day.cloud.daily.%y4%m2%d2.$ext
options template
tdef time 365 linear 12z1jan2006 24hr
EOF

end
end

cat> full.ddf <<EOF
dset /misc/prc19/colarco/c1440_NR_0.5000/day/full/c1440_NR.full.day.cloud.daily.%y4%m2%d2.nc
options template
tdef time 365 linear 12z1jan2006 24hr
EOF
