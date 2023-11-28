#!/bin/csh
# Program will make a copy of an input GFIO file as a same structured
# GFIO file but with all variables filled as undef

  set undef = /home/colarco/sourcemotel/FVGCM-hold/src/shared/gfio/r8/GFIO_undef_r8.x

# I decided to place the undef files in the same directory as the first data
# from the dataset I have

# Collection 5
# MOD04
  set inpDir = /output6/MISR/Level3/GRITAS/Y2000/M03
  set date = 20000301
  set algorithm = "F??_????"

  $undef -o $inpDir/undef.misr.aero.$date.hdf $inpDir/misr_$algorithm.aero.$date.hdf
