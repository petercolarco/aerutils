#!/bin/csh
  cd ..
  setenv BASEDIRAER ${PWD}
  cd icap
  if($?IDL_PATH == 0) setenv IDL_PATH ''
  setenv IDL_PATH ./:+${BASEDIRAER}/lib/idl:${IDL_PATH}

  idl idlscript
