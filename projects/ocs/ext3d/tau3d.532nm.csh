#!/bin/csh

cd /misc/prc11/colarco/aerutils/projects/ocs/ext3d
set wrkdir = `pwd`
echo $wrkdir

# Set up experiment information
  set EXPID = c48F_G40b11_ocs
  set inpdir = /misc/prc14/colarco/$EXPID/tavg3d_carma_v/
  set outdir = /misc/prc14/colarco/$EXPID/tavg3d_ext_v/
  /bin/mkdir -p $outdir

# Set up the AOD calculator
  set chemaod = ./Chem_Aod3d.x
  /bin/rm -f ExtData
  /bin/ln -s /share/colarco/fvInput ExtData

foreach yyyy ( 2001)
foreach mm ( FMA )

/bin/mkdir -p $outdir

set inpfile = $inpdir/$EXPID.tavg3d_carma_v.monthly.${yyyy}${mm}.nc4
set outfile = ./$EXPID.tavg3d_ext-532nm_v.monthly.${yyyy}${mm}.nc4
if(-e $inpfile) then
echo $inpfile
date

# Here's where the calculation is done

if(-e $outfile)  rm -f $outfile
 $chemaod -t Aod3d_532nm.rc -o $outfile $inpfile #>& /dev/null
 foreach file (`\ls -1 ${outfile}*`)
#  n4zip $file &
 end
 wait
date
endif

# End of calculation block

end

end
