#!/bin/csh
# Colarco, May 2006
# h4zip MODIS files

    set YEAR_TABLE = ( "2003" "2004" "2005" "2006")
    set MONTH_TABLE = ( "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" )
    set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

    set collection = 005
    set expid  = MYD04
    set expdir = /output/MODIS/Level3/${expid}/GRITAS/

    foreach yyyy (`echo $YEAR_TABLE`)
     foreach mm (`echo $MONTH_TABLE`)
      set dd = 00
      set DAYMAX = $DAY_TABLE[$mm]
      if( ( $yyyy == 2000 || $yyyy == 2004) && $mm == 02) set DAYMAX = 29
      while( $dd < $DAYMAX)
       @ dd = $dd + 1
       if( $dd < 10) set dd = 0$dd
       /home/colarco/bin/h4zip $expdir/Y$yyyy/M$mm/${expid}_L2_lnd.aero_${collection}.$yyyy$mm$dd.hdf
       /home/colarco/bin/h4zip $expdir/Y$yyyy/M$mm/${expid}_L2_ocn.aero_${collection}.$yyyy$mm$dd.hdf
      end
     end
    end
exit
