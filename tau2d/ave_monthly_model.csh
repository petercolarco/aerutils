#!/bin/csh
# Use this script to form a monthly average of the diag.sfc file (or other)
# Assumes daily averages already completed
# Requires FVGCM GFIO_mean_r8.x executable
#  exppath = path to experiment top level directory
#  expid   = name of experiment
# Output is stored in the relevant experiment directory

set monstr = (jan feb mar apr may jun jul aug sep oct nov dec)
set daystr = (31 28 31 30 31 30 31 31 30 31 30 31)


# Do it
foreach expid ( t002_b55 t003_c32 t005_b32 t006_b32)

set exppath  = /output/colarco/$expid/tau/

#foreach year (2000 2001 2002 2003 2004 2005)
foreach year (2006 )
foreach month (01 02 03 04 05 06 07 08 09 10 11 12)

set nday = $daystr[$month]
if( ( $year == 2000 || $year == 2004) && $month == 02) set nday = 29
set ntime = $nday
@ ntime = $ntime * 4
set tstr = "tdef time $ntime linear 0Z01$monstr[$month]$year 6hr"

cat > template.ddf << EOF
dset $exppath/Y${year}/M${month}/${expid}.tau2d.%y4%m2%d2.hdf
options template
undef 1e+15
$tstr
EOF

lats4d -i template.ddf -o test -ftype xdf -mean 
mv -f test.nc \
  $exppath/Y${year}/M{$month}/${expid}.tau2d.${year}${month}.hdf

end
end

end
