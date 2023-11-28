#!/bin/csh
  set expid  = "t003_c32"
  set expdir = "/misc/prc10/colarco/$expid/tau/"
  set NLEV = 8

  foreach YYYY (2000 2001 2002 2003 2004 2005 2006)
  foreach MM   (01 02 03 04 05 06 07 08 09 10 11 12)
  foreach DD   (01 02 03 04 05 06 07 08 09 10 \
                11 12 13 14 15 16 17 18 19 20 \
                21 22 23 24 25 26 27 28 29 30 31)

  set filename = $expdir/Y$YYYY/M$MM/$expid.tau2d.v4.$YYYY$MM$DD.hdf

if ( -e $filename ) then

cat > tmp.ddf << EOF
dset $filename
vars 1
du001=>aodtau $NLEV 99 Aerosol Optical Thickness
endvars
EOF

set dust = "du001.2+du002.2+du003.2+du004.2+du005.2"
set ss   = "ss001.2+ss002.2+ss003.2+ss004.2+ss005.2"
set fine = "ocphilic.2+ocphobic.2+bcphilic.2+bcphobic.2+so4.2"


# total AOT
set func = "-func "$dust"+"$ss"+"$fine
lats4d -i tmp.ddf -j $filename -o tmp $func
h4zip -shave tmp.nc
\mv -f tmp.nc $expdir/Y$YYYY/M$MM/$expid.tau2d.v4.total.$YYYY$MM$DD.hdf

## fine AOT
#set func = "-func "$fine
#lats4d -i tmp.ddf -j $filename -o tmp $func
#h4zip -shave tmp.nc
#\mv -f tmp.nc $expdir/Y$YYYY/M$MM/$expid.inst2d_ext_x.fineaot.$YYYY$MM${DD}_${HH}00z.hdf

\rm -f tmp.ddf

endif

end
end
end
