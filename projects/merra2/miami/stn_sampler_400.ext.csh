#!/bin/csh
  setenv PYTHONPATH ./:/home/colarco/sandbox/GAAS/Linux/lib/Python:/home/colarco/sandbox/GAAS/Linux/lib/Python/pyobs:/home/colarco/sandbox/GAAS/Linux/lib/Python/pyods:/usr/lib/portage/pym:/share/dasilva/epd/gaas/epd-7.3-2-rh5-x86_64:

  set outfile = ./MERRA2.inst3d_ext-532nm_v.20160728_20160805.nc4

  ./stn_sampler.py -v -o $outfile \
                   stn_sampler.csv inst3d_ext-532nm_v.ddf \
                         2016-07-28T00:00:00 2016-08-05T21:00:00


  end
