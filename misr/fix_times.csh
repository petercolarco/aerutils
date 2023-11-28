#!/bin/tcsh
  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/dasilva/OpenGrADS:$PATH

  set MON = ("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec")

  set YYYY  = 2000
  set MM    = 03
  set DD    = 01
  set SATID = MISR
  set RES   = d
  set algorithm = aero_F12_0022

  set UNDEF = 1

  set MODPATH = /misc/prc10/MISR/Level3/$RES/GRITAS


  foreach YYYY (2000 2001 2002 2003 2004 2005 2006 2007 2008 2009)
  foreach MM   (01 02 03 04 05 06 07 08 09 10 11 12)
  foreach DD   (01 02 03 04 05 06 07 08 09 10 \
                11 12 13 14 15 16 17 18 19 20 \
                21 22 23 24 25 26 27 28 29 30 \
                31)

  foreach qawt ("noqawt" "noqafl")


  set file = $MODPATH/Y$YYYY/M$MM/${SATID}_L2.${algorithm}.${qawt}.$YYYY$MM$DD.hdf
  if( -e $file ) then
   ls -l $file | grep "\->" > tmp.check
   set result = `awk '{print $10}' tmp.check`
   if( $result != '->') then

cat > tmp.ddf << EOF
dset $file
tdef time 8 linear 01:30z$DD$MON[$MM]$YYYY 3hr
EOF

    lats4d.sh -i tmp.ddf -o tmp -ftype xdf -geos0.5 -shave
    chmod g+s,g+w tmp.nc4
    \mv -f tmp.nc4 $MODPATH/Y$YYYY/M$MM/${SATID}_L2.${algorithm}.${qawt}.$YYYY$MM$DD.nc4

# Check for the undef files
    set file = $MODPATH/Y$YYYY/M$MM/undef.${SATID}_L2.${algorithm}.${qawt}.$YYYY$MM$DD.hdf
    if($UNDEF && -e $file) then
cat > tmp.ddf << EOF
dset $file
tdef time 8 linear 01:30z$DD$MON[$MM]$YYYY 3hr
EOF

    lats4d.sh -i tmp.ddf -o tmp -ftype xdf -geos0.5 -shave
    chmod g+s,g+w tmp.nc4
    \mv -f tmp.nc4 $MODPATH/Y$YYYY/M$MM/undef.${SATID}_L2.${algorithm}.${qawt}.$YYYY$MM$DD.nc4

    endif


   endif
  endif

end


end
end
end
