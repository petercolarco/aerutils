#!/bin/tcsh

# create some DDF files for the various extracts

foreach tle (gpm.nodrag sunsynch_500km.nodrag dual)

foreach swath (nadir 100 300 500 1000)

foreach type ("")

foreach MM ( 01 02 03 04 05 06 07 08 09 10 11 12)

set swath_ = ${swath}km
if ( `echo $swath` == "nadir") then 
 set swath_ = $swath
endif

set file = c1440_NR.$tle.${swath_}.${type}day.cloud.monthly.ddf

cat> $file <<EOF
dset /misc/prc19/colarco/c1440_NR_0.5000/month/c1440_NR.$tle.${swath_}.${type}day.cloud.monthly.%y4%m2.nc
options template
tdef time 12 linear 12z15jan2006 1mo
EOF


end
end


foreach type ("swt.")

foreach MM ( 01 02 03 04 05 06 07 08 09 10 11 12)

set file = c1440_NR.$tle.${swath_}.${type}day.monthly.ddf

cat> $file <<EOF
dset /misc/prc19/colarco/c1440_NR_0.5000/month/c1440_NR.$tle.${swath_}.${type}day.monthly.%y4%m2.nc
options template
tdef time 12 linear 12z15jan2006 1mo
EOF


end
end

end
end
