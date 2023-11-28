#!/bin/csh

# Make the trajectory sample
  ./trj_sampler.py -o G41prcR2010.trj.gocart.nc \
                   -r G41prcR2010.trj_sampler.gocart.rc -t csv -I csvfile

# Now do the extinction samples
  foreach lambda (385 449 521 602 676 756 869 1020)
  ./ext_sampler.py -i G41prcR2010.trj.gocart.nc -c $lambda \
                   -r Aod3d_sage3.rc \
                   -o G41prcR2010.ext_${lambda}nm.gocart.nc
  end

