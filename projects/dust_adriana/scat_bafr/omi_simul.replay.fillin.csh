#!/bin/tcsh
#/bin/tcsh -m
cd /misc/prc10/colarco/GAAS/src/Components/scat/adriana_bafr

#PythonPath
setenv PYTHONPATH ./://home/colarco/sandbox/GAAS/Linux/lib/Python://home/colarco/sandbox/GAAS/Linux/lib/Python/pyobs://home/colarco/sandbox/GAAS/Linux/lib/Python/pyods:$PYTHONPATH

# new
set ofiles = `\ls -1 /misc/prc19/colarco/OMAERUV_V187_DATA/2011/OMI-Aura_L2-OMAERUV_2011m0701t1[2,3,4,5,6,7,8,9]*he5`
set mfiles = `\ls -1 ../adriana/2011_a2_apport_frland_7_aer_L2-OMAERUV_2011m0701t1[2,3,4,5,6,7,8,9]*Full.npz`

# total number of files to process
#new
set nfiles = `\ls -1 /misc/prc19/colarco/OMAERUV_V187_DATA/2011/OMI-Aura_L2-OMAERUV_2011m0701t1[2,3,4,5,6,7,8,9]*he5 | wc -l`

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
