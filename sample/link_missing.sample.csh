#!/bin/csh
# Colarco, May 2008
# Search my MODIS directories for missing days of gridded data

# Specify the resolution as input (a, b, c, d, e)
  set years   = `echo 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016`
  set months  = `echo 01 02 03 04 05 06 07 08 09 10 11 12`
  set qastr   = `echo qast`
  set samples = `echo "." ".caliop1." ".caliop2." ".misr1." ".misr2." ".supermisr." ".caliop3." ".misr3." ".caliop4." ".misr4." `
  set samples = `echo "." ".caliop1." ".caliop2." ".misr1." ".misr2." ".supermisr." ".caliop3." ".misr3." ".caliop4." ".misr4." \
                          ".inverse_caliop1." ".inverse_caliop2." ".inverse_caliop3." ".inverse_caliop4." ".inverse_supermisr." \
                          ".inverse_misr1." ".inverse_misr2." ".inverse_misr3." ".inverse_misr4." `
  set samples = `echo "."`

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
  if($satid == 'MOD04') set set odsver = aero_tc8_006
  if($satid == 'MYD04') set set odsver = aero_tc8_006

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
#  set expdir = ./${satid}/${res}/GRITAS/

  set DAY_TABLE = ( "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )


  foreach qatype ($qastr)


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

       set missing = 0

       foreach sample ($samples)
        if( $satid == MOD04) then
         set basedate = "20000224"
         set missing_lnd = ../../Y2000/M02/undef.${satid}_L2_lnd$sample$odsver.$qatype{3}.$basedate.nc4
         set missing_ocn = ../../Y2000/M02/undef.${satid}_L2_ocn$sample$odsver.$qatype.$basedate.nc4
         set missing_blu = ../../Y2000/M02/undef.${satid}_L2_blu$sample$odsver.$qatype.$basedate.nc4
        else
         set basedate = "20030101"
         set missing_lnd = ../../Y2003/M01/undef.${satid}_L2_lnd$sample$odsver.$qatype{3}.$basedate.nc4
         set missing_ocn = ../../Y2003/M01/undef.${satid}_L2_ocn$sample$odsver.$qatype.$basedate.nc4
         set missing_blu = ../../Y2003/M01/undef.${satid}_L2_blu$sample$odsver.$qatype.$basedate.nc4
        endif

        ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_lnd$sample$odsver.$qatype{3}.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
        set result = `awk '{print $10}' tmp_link`
        if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_lnd$sample$odsver.$qatype{3}.$yyyy$mm$dd.nc4
        if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_lnd$sample$odsver.$qatype{3}.$yyyy$mm$dd.nc4) then 
         echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_lnd$sample$odsver.$qatype{3}.$yyyy$mm$dd.nc4
         ln -s $missing_lnd $expdir/Y$yyyy/M$mm/${satid}_L2_lnd$sample$odsver.$qatype{3}.$yyyy$mm$dd.nc4
         @ missing = $missing + 1
        endif

        ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_ocn$sample$odsver.$qatype.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
        set result = `awk '{print $10}' tmp_link`
        if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_ocn$sample$odsver.$qatype.$yyyy$mm$dd.nc4
        if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_ocn$sample$odsver.$qatype.$yyyy$mm$dd.nc4) then 
         echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_ocn$sample$odsver.$qatype.$yyyy$mm$dd.nc4
         ln -s $missing_ocn $expdir/Y$yyyy/M$mm/${satid}_L2_ocn$sample$odsver.$qatype.$yyyy$mm$dd.nc4
         @ missing = $missing + 1
        endif

        ls -l $expdir/Y$yyyy/M$mm/${satid}_L2_blu$sample$odsver.$qatype.$yyyy$mm$dd.nc4 | grep "\->" > tmp_link
        set result = `awk '{print $10}' tmp_link`
        if( $result == '->') rm -f $expdir/Y$yyyy/M$mm/${satid}_L2_blu$sample$odsver.$qatype.$yyyy$mm$dd.nc4
        if(! -e $expdir/Y$yyyy/M$mm/${satid}_L2_blu$sample$odsver.$qatype.$yyyy$mm$dd.nc4) then 
         echo New Link: $expdir/Y$yyyy/M$mm/${satid}_L2_blu$sample$odsver.$qatype.$yyyy$mm$dd.nc4
         ln -s $missing_blu $expdir/Y$yyyy/M$mm/${satid}_L2_blu$sample$odsver.$qatype.$yyyy$mm$dd.nc4
         @ missing = $missing + 1
        endif

       end

       echo MISSING COUNT $missing $yyyy$mm$dd

      end
     end
    end

end

exit
