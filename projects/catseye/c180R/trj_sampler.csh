#!/bin/csh

# Make the trajectory sample
  ./trj_sampler.py -v -r trj_sampler.rc -d 1 -o GEOS5 -t tle -I 2008214.tle 2008-07-01T00:00:00 2008-10-31T23:00:00
