#!/bin/csh -x
# Colarco, March 2006
# Use the hacked version of lats4d to sample both the model and the satellite to
# arrive at model monthly mean aot based on satellite sampling.

# Result is specific to the particular satellite compared to
# Result can easily be modified to give, e.g., daily means
# The version of lats4d here is seriously hacked and will not generally work!

# Here we sample on the local time of the model

  set gfio = /Users/colarco/bin/GFIO_mean_r8.x

  set outdir = /output/colarco/TOMS/Level3/b/GRITAS

  foreach yyyy (1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 \
                1989 1990 1991 1992 )
   foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

    $gfio -o $outdir/Y$yyyy/M$mm/TOMS.L3_aersl_n7t.$yyyy$mm.hdf \
             $outdir/Y$yyyy/M$mm/TOMS.L3_aersl_n7t.$yyyy${mm}??.hdf
    $gfio -o $outdir/Y$yyyy/M$mm/TOMS.L3_reflc_n7t.$yyyy$mm.hdf \
             $outdir/Y$yyyy/M$mm/TOMS.L3_reflc_n7t.$yyyy${mm}??.hdf


   end
  end

