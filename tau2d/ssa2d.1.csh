#!/bin/csh
# Script to generate tau2d fields from fvgcm output.
# Colarco, August 2005
# Home directory
set homedir = /Users/colarco/sandbox/aerutils/tau2d
set tmpdir  = $homedir

cd $tmpdir
\cp -f $homedir/.date1 .
\cp -f $homedir/Chem_Registry.rc .
\cp -f $homedir/Aod_Registry.rc .

set yyyy  = `cat $tmpdir/.date1 | awk '{print $1}'`
set mm  = `cat $tmpdir/.date1 | awk '{print $2}'`

echo $yyyy
echo $mm

if($mm < 10) then
set mm = 0$mm
endif


# Input directory
  set inpdir = /output/colarco/
  set outdir = /output/colarco/
  set expid = t005_b32

# Path to calculator
  set calc = $homedir/Chem_Aod.x
  set calcflags = '-geos4 -ssa2d -o '$expid


###############################################################################
# Should not have to modify below here
# Get 1 month worth of files
  foreach dd  (01 02 03 04 05 06 07 08 09 10 11 12 \
               13 14 15 16 17 18 19 20 21 22 23 24 \
               25 26 27 28 29 30 31)

  set inpfile = $inpdir$expid/chem/Y$yyyy/M$mm/$expid.chem.eta.$yyyy$mm$dd.hdf
#  \cp -f $inpfile .
#  set inpfile = ./$expid.chem.eta.$yyyy$mm$dd.hdf

   echo $calc $calcflags $inpfile
   $calc $calcflags $inpfile
   /bin/mkdir -p $outdir$expid/tau/Y$yyyy/M$mm
   /bin/mv -f $expid.tau2d.$yyyy$mm$dd.hdf \
    $outdir$expid/tau/Y$yyyy/M$mm/$expid.tau2d.$yyyy$mm$dd.hdf
   /bin/mv -f $expid.ssa2d.$yyyy$mm$dd.hdf \
    $outdir$expid/tau/Y$yyyy/M$mm/$expid.ssa2d.$yyyy$mm$dd.hdf

  rm -f $inpfile

  end

   
# increment the date
echo $yyyy $mm
@ mm = $mm + 1
if($mm > 12) then
@ yyyy = $yyyy + 1
@ mm = $mm - 12
endif

cat > $tmpdir/.date1 << EOF
$yyyy $mm
EOF


set mon = $mm
if($mon < 10) then
set mon = 0$mon
endif

if($yyyy$mon < 200101) then
 cd $homedir
 ./ssa2d.1.csh
endif
exit
