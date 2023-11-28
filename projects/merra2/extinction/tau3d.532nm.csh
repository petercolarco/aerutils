#!/bin/csh

cd /misc/prc11/colarco/aerutils/projects/merra2/extinction
set wrkdir = `pwd`
echo $wrkdir

# Set up experiment information
  set EXPID = MERRA2_400
  set inpdir = /misc/prc13/MERRA2/d5124_m2_jan10/
  set outdir = /misc/prc13/MERRA2/d5124_m2_jan10/
  /bin/mkdir -p $outdir

# Set up the AOD calculator
  set chemaod = ./Chem_Aod3d.x
  /bin/rm -f ExtData
  /bin/ln -s /share/colarco/fvInput ExtData

foreach yyyy ( 2014)
foreach mm ( 07 )

/bin/mkdir -p $outdir/Y$yyyy

foreach dd ( 17 18 19 20 21 )

set inpfile = $inpdir/Y${yyyy}/$EXPID.inst3_3d_aer_Nv.${yyyy}${mm}${dd}.nc4
set outfile = $outdir/Y${yyyy}/$EXPID.inst3_3d_ext-532nm_Nv.${yyyy}${mm}${dd}.nc4
#set outfile = ./$EXPID.inst3d_ext-532nm_v.${yyyy}${mm}${dd}_${hh}00z.nc4
if(-e $inpfile) then
echo $inpfile
date
if(-e $outfile)  rm -f $outfile
 $chemaod -t Aod3d_532nm.rc -bc -oc \
#          -dryaer \
          -o $outfile $inpfile #>& /dev/null
 foreach file (`\ls -1 ${outfile}*`)
  n4zip $file &
 end
 wait
date
endif


end

end

end
