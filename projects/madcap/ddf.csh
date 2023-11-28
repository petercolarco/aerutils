#!/bin/tcsh

  foreach ddf (calipso.ddf calipso_day.ddf calipso_day_cloud.ddf \
               calipso_swath.ddf calipso_swath_day.ddf calipso_swath_day_cloud.ddf \
               full.ddf full_day.ddf full_day_cloud.ddf)
  sed 's/monthly/swtnet\.monthly/g' $ddf > $ddf:r.swtnet.ddf

  end
