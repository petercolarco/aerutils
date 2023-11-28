#!/bin/csh
if ( -e /ford1/local/LF95/csh_setup ) then 
    source /ford1/local/LF95/csh_setup
endif

   cd /tmp/colarco

    set BIN_EXEC   = /home/colarco/futils/Linux/bin
    set BIN_EXEC   = /home/colarco/futils/src/odstools/gritas

# foreach INSTRUMENT ( MOD04 MYD04 )
 foreach INSTRUMENT ( MOD04 )
    set IN_DIR     = /output/MODIS/Level3/$INSTRUMENT
    set OUT_DIR    = /output/colarco/MODIS/Level3/$INSTRUMENT
    set TAG        = ${INSTRUMENT}_L2
    set RC_DIR     = $BIN_EXEC
    set RC_DIR     = /home/colarco/aerutils/modis

    set YEAR_TABLE = ( "2001")
#    set MONTH_TABLE = ( "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" )
    set MONTH_TABLE = ( "04" )
    set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

   foreach YYYY ( `echo $YEAR_TABLE` )
    foreach MM ( `echo $MONTH_TABLE` )

     mkdir -p  $OUT_DIR/GRITAS/Y$YYYY/M$MM
     chmod -R +X $OUT_DIR/GRITAS/Y$YYYY/M$MM/
     set DD = 00
     set DAYMAX = $DAY_TABLE[$MM]
     set DIR_IN  = $IN_DIR/ODS/Y$YYYY/M$MM
     while ( $DD < $DAYMAX )
       @ DD = $DD + 1
       if ( $DD < 10 ) then
        set DD = 0$DD
       endif
       set NYMD = $YYYY$MM$DD
       if ( -e $DIR_IN/$TAG.aero_005.obs.$NYMD.ods.gz ) then
        cp $DIR_IN/$TAG.aero_005.obs.$NYMD.ods.gz .
        gunzip $TAG.aero_005.obs.$NYMD.ods.gz
       else
        cp $DIR_IN/$TAG.aero_005.obs.$NYMD.ods .
       endif
       set IN_FILE  = $TAG.aero_005.obs.$NYMD.ods
       foreach TYPE ( land ocean )
        if ( $TYPE == land ) then
         set TYPE2 = lnd
        endif
        if ( $TYPE == ocean ) then
         set TYPE2 = ocn
        endif
        set OUT_FILE = ${TAG}_$TYPE2.aero_005.$NYMD
        if ( $INSTRUMENT == MOD04 ) then
         $BIN_EXEC/grisas.x -rc $RC_DIR/gritas.mod04.$TYPE.rc -res d -obs -o $OUT_FILE $IN_FILE
#         $BIN_EXEC/grisas.x -rc $RC_DIR/gritas.$TYPE.rc -res b -obs -o $OUT_FILE $IN_FILE
        else
         $BIN_EXEC/grisas.x -rc $RC_DIR/gritas.myd04.$TYPE.rc -res d -obs -o $OUT_FILE $IN_FILE
#         $BIN_EXEC/grisas.x -rc $RC_DIR/gritas.myd04.$TYPE.rc -res b -obs -o $OUT_FILE $IN_FILE
        endif
        mv -f ${OUT_FILE}.hdf $OUT_DIR/GRITAS/Y$YYYY/M$MM
       end
        rm -f $IN_FILE
     end
    end
   end
  end

# /output3/ravi/work/modisL2/run_gritas_monthly
