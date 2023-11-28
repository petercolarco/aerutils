#!/bin/tcsh

# create some DDF files for the various extracts

foreach tle (gpm.nodrag sunsynch_500km.nodrag)

foreach swath (nadir 100km 300km 500km 1000km)

foreach type ("" "swt." "swg.")

foreach MM ( 01 02 03 04 05 06 07 08 09 10 11 12)

set file = c1440_NR.$tle.${swath}.${type}day.cloud.monthly.ddf

cat> $file <<EOF
dset /misc/prc19/colarco/c1440_NR/NR/c1440_NR.$tle.${swath}.${type}day.cloud.monthly.%y4%m2.nc
options template
tdef time 12 linear 12z15jan2006 1mo
EOF


end
end
end
end
