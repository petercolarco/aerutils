#!/bin/csh
# Colarco, May 2008
# Search my MODIS directories for missing days of gridded data

# Create an undef file like this:
#  lats4d.sh -i input -o undef -func "maskout(@,-@)"
# works if no negatives in the file

# Specify the resolution as input (a, b, c, d, e)
  set years  = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009`
  set years  = `echo 2010`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`

  if ( $#argv < 2 ) then
   echo "Insufficient arguments for link_missing"
   echo "./link_missing.csh SATID RES"
   exit 1
  endif

# Satellite data
  set satid = $1
  if($satid != 'MOD04' && $satid != 'MYD04') then
   echo "SATID must be one of MOD04 or MYD04"
   exit 1
  endif
  if($satid == 'MOD04') set set odsver = nnr_001
  if($satid == 'MYD04') set set odsver = nnr_001
  set ntimes = 8         # number of times per day

# Resolution
  set res   = $2

  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/dasilva/OpenGrADS:$PATH

  set expdir = $MODISDIR/MODIS/NNR/051/Level3/${satid}/${res}/

  set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )


    if( $satid == MOD04) then
     set missing_blu = ../../Y2008/M01/undef.nc4
     set missing_lnd = ../../Y2008/M01/undef.nc4
     set missing_ocn = ../../Y2008/M01/undef.nc4
    else
     set missing_blu = ../../Y2008/M01/undef.nc4
     set missing_lnd = ../../Y2008/M01/undef.nc4
     set missing_ocn = ../../Y2008/M01/undef.nc4
    endif

    foreach yyyy ($years)
     foreach mm ($months)
      if(! -d $expdir/Y$yyyy/M$mm) /bin/mkdir -p $expdir/Y$yyyy/M$mm
      set d = 0
      set DAYMAX = $DAY_TABLE[$mm]
      if( ( $yyyy == 2000 || $yyyy == 2004 || $yyyy == 2008) && $mm == 02) set DAYMAX = 29
      while( $d < $DAYMAX)
       @ d = $d + 1
       set dd = $d
       if( $dd < 10) set dd = 0$dd

       foreach hh ( 00 03 06 09 12 15 18 21 )

       ls -l $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.land.$yyyy$mm${dd}_${hh}00z.nc4 | grep "\->" > tmp_link
       set result = `awk '{print $10}' tmp_link`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.land.$yyyy$mm${dd}_${hh}00z.nc4
       if(! -e $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.land.$yyyy$mm${dd}_${hh}00z.nc4) then
        echo New Link: $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.land.$yyyy$mm${dd}_${hh}00z.nc4
        ln -s $missing_lnd $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.land.$yyyy$mm${dd}_${hh}00z.nc4
       endif

       ls -l $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.ocean.$yyyy$mm${dd}_${hh}00z.nc4 | grep "\->" > tmp_link
       set result = `awk '{print $10}' tmp_link`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.ocean.$yyyy$mm${dd}_${hh}00z.nc4
       if(! -e $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.ocean.$yyyy$mm${dd}_${hh}00z.nc4) then
        echo New Link: $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.ocean.$yyyy$mm${dd}_${hh}00z.nc4
        ln -s $missing_ocn $expdir/Y$yyyy/M$mm/$odsver.${satid}_L3a.ocean.$yyyy$mm${dd}_${hh}00z.nc4
       endif

       end

      end
     end
    end

exit
