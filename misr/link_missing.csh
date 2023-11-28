#!/bin/csh
# Colarco, May 2006
# Search my MODIS directories for missing days of gridded data

# Specify the resolution as input (a, b, c, d, e)
  if ( $#argv < 1 ) then
   echo "Insufficient arguments for link_missing"
   exit 1
  endif

  set res = $1

    set YEAR_TABLE = ( "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017")
    set MONTH_TABLE = ( "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" )
    set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

    set qawts = noqawt
    set qafls = noqafl
    set algorithm = aero_tc8_F12_0022

    set expdir = /science/terra/misr/data/Level3/$res/GRITAS/

    set missing_lndfl = $expdir/Y2000/M03/undef.MISR_L2.$algorithm.noqafl.20000301.nc4
    set missing_lndwt = $expdir/Y2000/M03/undef.MISR_L2.$algorithm.noqawt.20000301.nc4


    foreach yyyy (`echo $YEAR_TABLE`)
     foreach mm (`echo $MONTH_TABLE`)
      if(! -d $expdir/Y$yyyy/M$mm) /bin/mkdir -p $expdir/Y$yyyy/M$mm
      set d = 0
      set DAYMAX = $DAY_TABLE[$mm]
      if( ( $yyyy == 2000 || $yyyy == 2004) && $mm == 02) set DAYMAX = 29
      while( $d < $DAYMAX)
       @ d = $d + 1
       set dd = $d
       if( $dd < 10) set dd = 0$dd

       ls -l $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qafls.$yyyy$mm$dd.nc4 | grep "\->" > tmp
       set result = `awk '{print $10}' tmp`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qafls.$yyyy$mm$dd.nc4
       if(! -e $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qafls.$yyyy$mm$dd.nc4) then 
        echo New Link: $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.005.$qafls.$yyyy$mm$dd.nc4
        ln -s $missing_lndfl $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qafls.$yyyy$mm$dd.nc4
       endif

       ls -l $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qawts.$yyyy$mm$dd.nc4 | grep "\->" > tmp
       set result = `awk '{print $10}' tmp`
       if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qawts.$yyyy$mm$dd.nc4
       if(! -e $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qawts.$yyyy$mm$dd.nc4) then 
        echo New Link: $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.005.$qawts.$yyyy$mm$dd.nc4
        ln -s $missing_lndwt $expdir/Y$yyyy/M$mm/MISR_L2.$algorithm.$qawts.$yyyy$mm$dd.nc4
       endif


      end
     end
    end
exit
