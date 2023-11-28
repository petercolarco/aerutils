#!/bin/tcsh
  set input  = "http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/candidate_fp/fcast/inst1_2d_hwl_Nx/inst1_2d_hwl_Nx.20101027_00z"
  set date   = "12z27oct2010"
  set output = "./inst1_2d_hwl_Nx.20101027_00z+20101027_12z"

  lats4d.sh -i $input -o $output -time $date $date -vars duexttau suexttau ocexttau bcexttau ssexttau -geos1x125a
