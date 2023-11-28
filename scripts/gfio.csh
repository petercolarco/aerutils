#!/bin/csh
# Use this script to average with GFIO_mean_r8.x

set gfiomean = /Users/colarco/bin/GFIO_mean_r8.x
set exppath  = /output/colarco/
set expid    = t003_c32


mkdir -p $exppath/$expid/diag/clim

foreach expid (t002_b55 t005_b32 t006_b32)

foreach yyyy (2000 2001 2002 2003 2004 2005 2006)

  $gfiomean -o $exppath/$expid/diag/Y$yyyy/${expid}.chem_diag.sfc.$yyyy.hdf \
               $exppath/$expid/diag/Y$yyyy/M??/${expid}.chem_diag.sfc.${yyyy}??.hdf
  $gfiomean -o $exppath/$expid/diag/Y$yyyy/${expid}.chem_diag.eta.$yyyy.hdf \
               $exppath/$expid/diag/Y$yyyy/M??/${expid}.chem_diag.eta.${yyyy}??.hdf

end

end

