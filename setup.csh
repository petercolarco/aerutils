#!/bin/csh
# Example csh script to set environment appropriately.
# Could be run each time you want to enter a session of using this code.

  setenv BASEDIRAER ${PWD}
  if($?IDL_PATH == 0) setenv IDL_PATH ''
  setenv IDL_PATH ./:${BASEDIRAER}/lib/idl:${BASEDIRAER}/lib/idl/textoidl:${IDL_PATH}

# Update PYTHONPATH
  if($?PYTHONPATH == 0) setenv PYTHONPATH ''
  setenv PYTHONPATH ${BASEDIRAER}/lib/python:${PYTHONPATH}

# IDL Guide 5
  source $BASEDIRAER/lib/idl/idl_guide5/guide5.csh

# set some data directories
  set host = `uname -n`
  setenv AERONETDIR /Users/pcolarco/data/AERONET/
  setenv SFCOBSDIR  /Volumes/pcolarco/
  setenv MODISDIR   /Users/pcolarco/data/
  setenv MODELDIR   /Users/pcolarco/data/

  if ( $host == 'calculon.gsfc.nasa.gov') then
   setenv AERONETDIR /output/colarco/AERONET/
   setenv SFCOBSDIR  /output/colarco/
   setenv MODISDIR   /output/colarco/
   setenv MODELDIR   /output/colarco/
  endif
  if ( $host == 'syrinx.gsfc.nasa.gov') then
   setenv AERONETDIR /misc/prc10/AERONET/
   setenv SFCOBSDIR  /misc/prc10/
   setenv MODISDIR   /misc/prc10/
   setenv MODELDIR   /misc/prc10/colarco
  endif
  if ( $host == 'bender.gsfc.nasa.gov') then
   setenv AERONETDIR /misc/prc10/AERONET/V2/
   setenv SFCOBSDIR  /misc/prc10/
   setenv MODISDIR   /science/modis/data/
   setenv MODELDIR   /misc/prc10/colarco/
  endif

