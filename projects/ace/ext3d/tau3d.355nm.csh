#!/bin/csh

cd /misc/prc11/colarco/aerutils/projects/ace/ext3d
set wrkdir = `pwd`
echo $wrkdir

# Set up experiment information
  set EXPID = c48R_G40b11_carma
  set inpdir = /misc/prc14/colarco/$EXPID/inst3d_carma_v/
  set outdir = /misc/prc14/colarco/$EXPID/inst3d_ext_v/
  /bin/mkdir -p $outdir

# Set up the AOD calculator
  set chemaod = ./Chem_Aod3d.x
  /bin/rm -f ExtData
  /bin/ln -s /share/colarco/fvInput ExtData

foreach yyyy ( 2009)
foreach mm ( 07 )
foreach dd (14 15 16)
foreach hh (00 03 06 09 12 15 18 21)
/bin/mkdir -p $outdir

set inpfile = $inpdir/$EXPID.inst3d_carma_v.${yyyy}${mm}${dd}_${hh}00z.nc4
set outfile = ./$EXPID.inst3d_ext-355nm_v.${yyyy}${mm}${dd}_${hh}00z.nc4
if(-e $inpfile) then
echo $inpfile
date
if(-e $outfile)  rm -f $outfile
 $chemaod -t Aod3d_355nm.rc -o $outfile $inpfile #>& /dev/null
 foreach file (`\ls -1 ${outfile}*`)
#  n4zip $file &
 end
 wait
date
endif

end
end
end
end
