#!/bin/tcsh
#/bin/tcsh -m

#PythonPath
#setenv PYTHONPATH ./:/misc/prc08/colarco/GAAS/Linux/lib/Python:/misc/prc08/colarco/GAAS/Linux/lib/Python/pyobs:/misc/prc08/colarco/GAAS/Linux/lib/Python/pyods:$PYTHONPATH

# new
set ofiles = `\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0605t*he5`
set mfiles = `\ls -1 /misc/prc15/colarco/dR_MERRA-AA-r2-v1621/inst3d_aer_v/Y2007/M06/dR_MERRA-AA-r2-v1621_aer_L2-OMAERUV_2007m0605t*Full.npz`

# total number of files to process
#new
set nfiles = `\ls -1 /misc/prc08/colarco/OMAERUV_V1621_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0605t*he5 | wc -l`

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
sed 's#OMIFN#'$ofiles[$ifile]'#g;s#MODFN#'$mfiles[$ifile]:t'#g;s#MODDIR#'$mfiles[$ifile]:h'#g;s#DUV#v15_3#g' omi_simul.replay.tmp > omi_simul.fillin.$ifile

python omi_simul.fillin.$ifile > omi_simul.out.$ifile &
#wait

#rm -f omi_simul.fillin

@ ifile = $ifile + 1

end
