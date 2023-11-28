#!/bin/tcsh
#/bin/tcsh -m

#PythonPath
setenv PYTHONPATH ./://home/colarco/sandbox/GAAS/Linux/lib/Python://home/colarco/sandbox/GAAS/Linux/lib/Python/pyobs://home/colarco/sandbox/GAAS/Linux/lib/Python/pyods:$PYTHONPATH

# new
set ofiles = `\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0617t0[6,7]*he5`
set mfiles = `\ls -1 ./c90Fc_I10pa3_pin_aer_L2-OMAERUV_2007m0617t0[6,7]*Full.npz`

# total number of files to process
#new
set nfiles = `\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0617t0[6,7]*he5 | wc -l`

# How many (integer) times does number of processors go into nfiles?
set nwhole = `expr $nfiles / 28`
set nmod   = `expr $nfiles \% 28`  #nmod procs need to do one extra file

# What file to start at?
set iproc = 0
set istart = `expr $iproc \* $nwhole \+ 1`
if( $iproc < $nmod ) then
@ istart = $istart + $iproc
set ncount = `expr $nwhole + 1`
else
@ istart = $istart + $nmod
set ncount = $nwhole
endif

echo $iproc $istart $ncount $nfiles $nmod  $nwhole

set ifile = $istart

while ($ifile <= $nfiles)
sed 's#OMIFN#'$ofiles[$ifile]'#g;s#MODFN#'$mfiles[$ifile]:t'#g;s#MODDIR#'$mfiles[$ifile]:h'#g' toms_simul.tmp > toms_simul.fillin.$ifile

python toms_simul.fillin.$ifile > toms_simul.out.$ifile &
#wait

#rm -f toms_simul.fillin

@ ifile = $ifile + 1

end
