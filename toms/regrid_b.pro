#!/bin/csh
# Colarco, May 2006
# Search my MODIS directories for missing days of gridded data

    set YEAR_TABLE = ( 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 \
                       1989 1990 1991 1992 )
    set MONTH_TABLE = ( "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" )
    set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

    set expdir = /output5/colarco/TOMS/Level3/1x125/GRITAS/
    set outdir = /output5/colarco/TOMS/Level3/b/GRITAS/

    foreach yyyy (`echo $YEAR_TABLE`)
     foreach mm (`echo $MONTH_TABLE`)
      if(! -d $outdir/Y$yyyy/M$mm) /bin/mkdir -p $outdir/Y$yyyy/M$mm
      set dd = 00
      set DAYMAX = $DAY_TABLE[$mm]
      if( ( $yyyy == 1980 || $yyyy == 1984 || $yyyy == 1988 || $yyyy == 1992 || \
            $yyyy == 1996 || $yyyy == 2000 || $yyyy == 2004) && $mm == 02) set DAYMAX = 29
      while( $dd < $DAYMAX)
       @ dd = $dd + 1
       if( $dd < 10) set dd = 0$dd
       lats4d -i $expdir/Y$yyyy/M$mm/TOMS.L3_aersl_n7t.$yyyy$mm$dd.hdf \
              -o test -fv2x25a
       h4zip -shave test.nc
       \mv -f test.nc $outdir/Y$yyyy/M$mm/TOMS.L3_aersl_n7t.$yyyy$mm$dd.hdf
       lats4d -i $expdir/Y$yyyy/M$mm/TOMS.L3_reflc_n7t.$yyyy$mm$dd.hdf \
              -o test -fv2x25a
       h4zip -shave test.nc
       \mv -f test.nc $outdir/Y$yyyy/M$mm/TOMS.L3_reflc_n7t.$yyyy$mm$dd.hdf
      end
     end
    end
exit
