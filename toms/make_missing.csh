#!/bin/csh
# Program will make a copy of an input GFIO file as a same structured
# GFIO file but with all variables filled as undef

  set undef = /home/colarco/sourcemotel/FVGCM-hold/src/shared/gfio/r8/GFIO_undef_r8.x

# I decided to place the undef files in the same directory as the first data
# from the dataset I have

  set inpDir = /output5/colarco/TOMS/Level3/1x125/GRITAS/Y1979/M01
  set date = 19790101
  $undef -o $inpDir/undef_ai.TOMS.L3_aersl_n7t.$date.hdf $inpDir/TOMS.L3_aersl_n7t.$date.hdf
  $undef -o $inpDir/undef_ref.TOMS.L3_reflc_n7t.$date.hdf $inpDir/TOMS.L3_reflc_n7t.$date.hdf
