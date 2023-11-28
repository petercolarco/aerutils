#!/bin/csh
# Script to generate tau2d fields from fvgcm output.
# Colarco, August 2005
# Home directory
set homedir = /Users/colarco/sandbox/aerutils/tau2d
set expid = d5_tc4_01
set inpdir = /output/tc4/$expid/das/diag/
set outdir = /output/tc4/$expid/das/tau/

# Path to calculator
  set calc = $homedir/Chem_Aod.x
  set calcflags = '-o '$expid


###############################################################################
  foreach yyyy (2007)
  foreach mm (07 08 09 10)


  foreach dd  (01 02 03 04 05 06 07 08 09 10 11 12 \
               13 14 15 16 17 18 19 20 21 22 23 24 \
               25 26 27 28 29 30 31)

  foreach hh  (00 06 12 18)

   set inpfile = $inpdir/Y$yyyy/M$mm/$expid.inst3d_aer_v.$yyyy$mm${dd}_${hh}00z.hdf

   echo $calc $calcflags $inpfile
   $calc $calcflags $inpfile

   /bin/mkdir -p $outdir/Y$yyyy/M$mm/
   /bin/mv -f $expid.tau2d.$yyyy$mm$dd.hdf \
    $outdir/Y$yyyy/M$mm/$expid.tau2d.$yyyy$mm${dd}_${hh}00z.hdf

  end

  end

  end
  end
   
