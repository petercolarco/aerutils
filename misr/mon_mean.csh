#!/bin/csh
foreach yyyy (2006)
 foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)
  GFIO_mean_r8.x -o Y$yyyy/M$mm/MISR_L2.aero.noqawt.$yyyy$mm.hdf \
                    Y$yyyy/M$mm/MISR_L2.aero.noqawt.$yyyy${mm}??.hdf
  h4zip -shave Y$yyyy/M$mm/MISR_L2.aero.noqawt.$yyyy$mm.hdf
  end
end
