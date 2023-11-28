#!/bin/tcsh

# create some DDF files for the various extracts

foreach tle (gpm.nodrag sunsynch_500km.nodrag sunsynch_450km_1330crossing.nodrag)

foreach swath (nadir 100 300 500 1000)

foreach type ("")

foreach MM ( 01 02 03 04 05 06 07 08 09 10 11 12)

set swath_ = ${swath}km
if ( `echo $swath` == "nadir") then 
 set swath_ = $swath
endif

set file = c1440_NR.$tle.${swath_}.${type}day.cloud.daily.ddf

cat> $file <<EOF
dset /misc/prc19/colarco/c1440_NR_0.5000/day/$tle/c1440_NR.$tle.${swath_}.${type}day.cloud.daily.%y4%m2%d2.nc
options template
tdef time 365 linear 12z1jan2006 24hr
EOF


end
end


foreach type ("swt.")

foreach MM ( 01 02 03 04 05 06 07 08 09 10 11 12)

set file = c1440_NR.$tle.${swath_}.${type}day.daily.ddf

cat> $file <<EOF
dset /misc/prc19/colarco/c1440_NR_0.5000/day/$tle/c1440_NR.$tle.${swath_}.${type}day.daily.%y4%m2%d2.nc
options template
tdef time 365 linear 12z1jan2006 24hr
EOF


end
end

end
end
