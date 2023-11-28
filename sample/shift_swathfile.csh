#!/bin/tcsh
# This script will take as input the SWATH files that
# Ravi generated and created shifted SWATH files that
# move the grids 5 degrees west (to get subpoint/misr
# out of sunglint).
# NOTE: vote averaging result.

  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/colarco/OpenGrADS:$PATH

  set swath = /misc/prc10/MODIS/Level3/MOD04/SWATH_d/


  set YYYY = 2001
  set MM   = 01
  set DD   = 01

  foreach YYYY ( 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009)
  foreach MM   ( 01 02 03 04 05 06 07 08 09 10 11 12 )
  foreach DD   ( 01 02 03 04 05 06 07 08 09 10 \
                 11 12 13 14 15 16 17 18 19 20 \
                 21 22 23 24 25 26 27 28 29 30 31 )

  set swathf = $swath/Y$YYYY/M$MM/mod04_d-t+03hourly.mask.sfc.$YYYY$MM$DD.nc4
  set rand = `ps -A | sum | cut -c1-5`
  ls -l $swathf | grep "\->" > tmp.$rand
  set result = `awk '{print $10}' tmp.$rand`
  /bin/rm -f tmp.$rand
  if( -e $swathf && $result != '->') then
  echo $swathf
cat > mod04.$rand.ddf << EOF
dset $swathf
undef 1e16
xdef longitude 540 linear -185 0.666666
EOF

  lats4d.sh -i mod04.$rand.ddf -o tmp.$rand -ftype xdf -geos0.5v -shave
  chmod g+s,g+w tmp.$rand.nc4

  \mv -f tmp.$rand.nc4 $swath/Y$YYYY/M$MM/mod04_d-t+03hourly.mask.sfc.shift.$YYYY$MM$DD.nc4
  \rm -f mod04.$rand.ddf

  endif

  end
  end
  end

