#!/bin/csh
# Colarco, May 2008
# Search my MODIS directories for missing days of gridded data

# Specify the resolution as input (a, b, c, d, e)
  set years  = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014`
  set months = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr  = `echo qawt noqawt qawt3`

  if ( $#argv < 2 ) then
   echo "Insufficient arguments for link_missing"
   echo "./link_missing.csh SATID RES {YYYY MM QA}"
   exit 1
  endif

  if ( $#argv > 2 && $#argv != 5 ) then
   echo "Insufficient arguments for link_missing"
   echo "./link_missing.csh SATID RES YYYY MM QA "
   exit 1
  endif

# Satellite data
  set satid = $1
  if($satid != 'MOD04' && $satid != 'MYD04') then
   echo "SATID must be one of MOD04 or MYD04"
   exit 1
  endif
  if($satid == 'MOD04') set set odsver = aero_tc8_051
  if($satid == 'MYD04') set set odsver = aero_tc8_051
  set ntimes = 8         # number of times per day

# Resolution
  set res   = $2

  if ( $#argv > 2 ) then
   set years  = $3
   set months = $4
   set qastr  = $5
  endif

  unsetenv GAUDXT
  unsetenv GASCRP
  unsetenv GADDIR
  setenv PATH /share/dasilva/OpenGrADS:$PATH

  set expdir = $MODISDIR/Level3/${satid}/hourly/${res}/GRITAS/

  set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )


  foreach qatype ($qastr)


    if( $qatype == "qawt") then
     set qawts = qawt
     set qafls = qafl
    else if( $qatype == "noqawt") then
     set qawts = noqawt
     set qafls = noqafl
    else if( $qatype == "qawt3") then
     set qawts = qawt3
     set qafls = qafl3
    endif

    if( $satid == MOD04) then
     set basedate = "20030101"
     set missing_blu_qawt = ../../Y2000/M02/undef.${satid}_L2_blu.$odsver.$qawts.$basedate.nc4
     set missing_blu_qafl = ../../Y2000/M02/undef.${satid}_L2_blu.$odsver.$qafls.$basedate.nc4
     set missing_lnd_qawt = ../../Y2000/M02/undef.${satid}_L2_lnd.$odsver.$qawts.$basedate.nc4
     set missing_lnd_qafl = ../../Y2000/M02/undef.${satid}_L2_lnd.$odsver.$qafls.$basedate.nc4
     set missing_ocn_qawt = ../../Y2000/M02/undef.${satid}_L2_ocn.$odsver.$qawts.$basedate.nc4
     set missing_ocn_qafl = ../../Y2000/M02/undef.${satid}_L2_ocn.$odsver.$qafls.$basedate.nc4
    else
     set basedate = "20030101"
     set missing_blu_qawt = ../../Y2003/M01/undef.${satid}_L2_blu.$odsver.$qawts.$basedate.nc4
     set missing_blu_qafl = ../../Y2003/M01/undef.${satid}_L2_blu.$odsver.$qafls.$basedate.nc4
     set missing_lnd_qawt = ../../Y2003/M01/undef.${satid}_L2_lnd.$odsver.$qawts.$basedate.nc4
     set missing_lnd_qafl = ../../Y2003/M01/undef.${satid}_L2_lnd.$odsver.$qafls.$basedate.nc4
     set missing_ocn_qawt = ../../Y2003/M01/undef.${satid}_L2_ocn.$odsver.$qawts.$basedate.nc4
     set missing_ocn_qafl = ../../Y2003/M01/undef.${satid}_L2_ocn.$odsver.$qafls.$basedate.nc4
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

       ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qafls.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
       set result = `awk '{print $10}' tmp_link`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qafls.$yyyy$mm$dd.nc4
       if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qafls.$yyyy$mm$dd.nc4) then 
        echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qafls.$yyyy$mm$dd.nc4
        ln -s $missing_lnd_qafl $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qafls.$yyyy$mm$dd.nc4
       endif

       ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qawts.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
       set result = `awk '{print $10}' tmp_link`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qawts.$yyyy$mm$dd.nc4
       if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qawts.$yyyy$mm$dd.nc4) then 
        echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qawts.$yyyy$mm$dd.nc4
        ln -s $missing_lnd_qawt $expdir/Y$yyyy/M$mm/${satid}_L2_lnd.$odsver.$qawts.$yyyy$mm$dd.nc4
       endif

       ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qafls.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
       set result = `awk '{print $10}' tmp_link`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qafls.$yyyy$mm$dd.nc4
       if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qafls.$yyyy$mm$dd.nc4) then 
        echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qafls.$yyyy$mm$dd.nc4
        ln -s $missing_ocn_qafl $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qafls.$yyyy$mm$dd.nc4
       endif

       ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qawts.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
       set result = `awk '{print $10}' tmp_link`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qawts.$yyyy$mm$dd.nc4
       if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qawts.$yyyy$mm$dd.nc4) then 
        echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qawts.$yyyy$mm$dd.nc4
        ln -s $missing_ocn_qawt $expdir/Y$yyyy/M$mm/${satid}_L2_ocn.$odsver.$qawts.$yyyy$mm$dd.nc4
       endif

#      Deep Blue
#       if($satid == 'MYD04' && $qawts == 'qawt3' && $odsver == 'aero_tc8_051') then
       if( $qawts == 'qawt3' && $odsver == 'aero_tc8_051') then
        ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qafls.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
        set result = `awk '{print $10}' tmp_link`
        if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qafls.$yyyy$mm$dd.nc4
        if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qafls.$yyyy$mm$dd.nc4) then 
         echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qafls.$yyyy$mm$dd.nc4
         ln -s $missing_blu_qafl $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qafls.$yyyy$mm$dd.nc4
        endif

        ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qawts.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
        set result = `awk '{print $10}' tmp_link`
        if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qawts.$yyyy$mm$dd.nc4
        if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qawts.$yyyy$mm$dd.nc4) then 
         echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qawts.$yyyy$mm$dd.nc4
         ln -s $missing_blu_qawt $expdir/Y$yyyy/M$mm/${satid}_L2_blu.$odsver.$qawts.$yyyy$mm$dd.nc4
        endif
       endif

      end
     end
    end

end
exit
