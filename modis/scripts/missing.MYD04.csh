#!/bin/csh
# Colarco, May 2006
# Search my MODIS directories for missing days of gridded data

    set YEAR_TABLE = ( "2003" "2004")
    set MONTH_TABLE = ( "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" )
    set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

    set expid  = MYD04
    set expdir = /output/colarco/MODIS/collection5/Level3/MYD04/GRITAS/
    set missing_lnd = /output/colarco/MODIS/Level3/GRITAS/Y2000/M03/undef_lnd.hdf
    set missing_ocn = /output/colarco/MODIS/Level3/GRITAS/Y2000/M03/undef_ocn.hdf

    foreach yyyy (`echo $YEAR_TABLE`)
     foreach mm (`echo $MONTH_TABLE`)
      set dd = 00
      set DAYMAX = $DAY_TABLE[$mm]
      if( ( $yyyy == 2000 || $yyyy == 2004) && $mm == 02) set DAYMAX = 29
      while( $dd < $DAYMAX)
       @ dd = $dd + 1
       if( $dd < 10) set dd = 0$dd
       if(! -e $expdir/Y$yyyy/M$mm/${expid}_L2_lnd.aero_005.$yyyy$mm$dd.hdf) then 
        echo $expdir/Y$yyyy/M$mm/${expid}_L2_lnd.aero_005.$yyyy$mm$dd.hdf
        ln -s $missing_lnd $expdir/Y$yyyy/M$mm/${expid}_L2_lnd.aero_005.$yyyy$mm$dd.hdf
       endif
       if(! -e $expdir/Y$yyyy/M$mm/${expid}_L2_ocn.aero_005.$yyyy$mm$dd.hdf) then
        echo $expdir/Y$yyyy/M$mm/${expid}_L2_ocn.aero_005.$yyyy$mm$dd.hdf
        ln -s $missing_ocn $expdir/Y$yyyy/M$mm/${expid}_L2_ocn.aero_005.$yyyy$mm$dd.hdf
       endif
      end
     end
    end
exit
