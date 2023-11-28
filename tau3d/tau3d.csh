#!/bin/csh

#Set environment for ifort
# source /opt/intel_fc_80/bin/ifortvars.csh

#Script for calculating 2d AOT from chem.eta files

#Where are we?
set homedir = /home/colarco/sandbox/ARCTAS/aerutils/tau3d
set expid = d5_arctas_02
set inpdir = /misc/prc08/arctas/$expid/das/
set outdir = /misc/prc08/arctas/$expid/das/

#Chem_Aod.x?
set chemaod = $homedir/Chem_Aod3d.x


#Do it!

foreach yyyy (2008)
 foreach mm (04 )
  foreach dd ( 17 18 19 20 \
               21 22 23 24 25 26 27 28 29 30 31 )

  mkdir -p $outdir/Y$yyyy/M$mm/D$dd

  foreach hh ( 00 06 12 18)

echo    $chemaod -dust -su -ss -o $outdir/Y$yyyy/M$mm/D$dd/test $inpdir/Y$yyyy/M$mm/D$dd/$expid.inst3d_aer_v.$yyyy$mm${dd}_${hh}00z.hdf
        $chemaod -dust -su -ss -o $outdir/Y$yyyy/M$mm/D$dd/test $inpdir/Y$yyyy/M$mm/D$dd/$expid.inst3d_aer_v.$yyyy$mm${dd}_${hh}00z.hdf
echo    $chemaod -anthro -oc -bc -o $outdir/Y$yyyy/M$mm/D$dd/test $inpdir/Y$yyyy/M$mm/D$dd/$expid.inst3d_aer_v.$yyyy$mm${dd}_${hh}00z.hdf
        $chemaod -anthro -oc -bc -o $outdir/Y$yyyy/M$mm/D$dd/test $inpdir/Y$yyyy/M$mm/D$dd/$expid.inst3d_aer_v.$yyyy$mm${dd}_${hh}00z.hdf

      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.total.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.total.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.dust.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.dust.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.su.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.su.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.oc.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.oc.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.bc.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.bc.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.ss.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.ss.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      \mv -f $outdir/Y$yyyy/M$mm/D$dd/test.anthro.tau3d.$yyyy$mm$dd.hdf \
             $outdir/Y$yyyy/M$mm/D$dd/$expid.anthro.tau3d.$yyyy$mm${dd}_${hh}00z.hdf

      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.total.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.dust.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.su.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.ss.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.oc.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.bc.tau3d.$yyyy$mm${dd}_${hh}00z.hdf
      h4zip -shave $outdir/Y$yyyy/M$mm/D$dd/$expid.anthro.tau3d.$yyyy$mm${dd}_${hh}00z.hdf

  end

  end
exit
 end
end
