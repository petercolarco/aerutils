#!/bin/csh
# Program will make a copy of an input GFIO file as a same structured
# GFIO file but with all variables filled as undef

  set undef = /home/colarco/sourcemotel/FVGCM-hold/src/shared/gfio/r8/GFIO_undef_r8.x

# I decided to place the undef files in the same directory as the first data
# from the dataset I have

# Collection 5
# MOD04
#  set inpDir = /output6/MODIS/Level3/MOD04/GRITAS/Y2000/M02
#  set date = 20000224
#  $undef -o $inpDir/undef_lnd.MOD04_L2_lnd.aero_005.$date.hdf $inpDir/MOD04_L2_lnd.aero_005.$date.hdf
#  $undef -o $inpDir/undef_ocn.MOD04_L2_ocn.aero_005.$date.hdf $inpDir/MOD04_L2_ocn.aero_005.$date.hdf

# MYD04
  set inpDir = /output6/MODIS/Level3/MYD04/GRITAS/Y2003/M01
  set date = 20030101
  $undef -o $inpDir/undef_lnd.MYD04_L2_lnd.aero_005.$date.hdf $inpDir/MYD04_L2_lnd.aero_005.$date.hdf
  $undef -o $inpDir/undef_ocn.MYD04_L2_ocn.aero_005.$date.hdf $inpDir/MYD04_L2_ocn.aero_005.$date.hdf
